//
//  URL+XCallback.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 25.04.2025.
//

import Foundation

extension URL {
  package enum Reserved {
    package static let host: String = "x-callback-url"
    package static let parameterPrefix = "x-"
    package enum ParameterName: String {
      case source = "x-source"
      case success = "x-success"
      case error = "x-error"
      case cancel = "x-cancel"
    }
  }

  public static func xCallbackURL(
    scheme: String,
    action: String,
    callbacks: CallbacksConfiguration,
    parameters: [URLQueryItem]? = nil
  ) throws(XCallbackURLFailure) -> URL {
    var components = try baseURLComponents(scheme: scheme, action: action)
    if let parameters, !parameters.isEmpty {
      components.queryItems = (components.queryItems ?? []) + parameters
    }

    if let invalidParameters = components.queryItems?.filter({
      $0.name.hasPrefix(Reserved.parameterPrefix)
    }), !invalidParameters.isEmpty {
      throw .denyedParamareterNames(invalidParameters.map(\.name))
    }

    components.addQueryItems(from: callbacks)

    guard let result = components.url else {
      throw .invalidURLComponents(components)
    }

    return result
  }

  private static func baseURLComponents(scheme: String, action: String) throws(XCallbackURLFailure)
    -> URLComponents
  {
    guard scheme.isValidURLScheme else {
      throw .invalidScheme
    }
    guard !action.isEmpty else {
      throw .emptyAction
    }

    var components = URLComponents()
    components.scheme = scheme
    components.host = Reserved.host
    components.path = action.hasPrefix("/") ? action : "/\(action)"
    return components
  }
}

extension URLComponents {
  fileprivate mutating func addQueryItems(from configuration: CallbacksConfiguration) {
    var items: [URLQueryItem] = queryItems ?? []
    let namedValues: KeyValuePairs<URL.Reserved.ParameterName, String?> = [
      .source: configuration.source,
      .success: configuration.onSuccess?.url.absoluteString,
      .error: configuration.onError?.url.absoluteString,
      .cancel: configuration.onCancel?.url.absoluteString,
    ]

    for element in namedValues {
      if let value = element.value, !value.isEmpty {
        items.append(URLQueryItem(name: element.key.rawValue, value: value))
      }
    }

    queryItems = items
  }
}
