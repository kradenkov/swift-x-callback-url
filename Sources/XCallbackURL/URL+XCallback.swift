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

    /// Creates an x-callback-url according to the [x-callback-url specification](https://x-callback-url.com/specification/)
    /// - Parameters:
    ///   - scheme: The URL scheme of the target app that will handle the request. Must be a valid URL scheme.
    ///   - action: The specific action to be executed by the target app, including any action-specific parameters.
    ///   - parameters: Configuration containing optional source app identifier and callback URLs for success, error and cancel cases.
    /// - Returns: A URL conforming to the structure: `[scheme]://x-callback-url/[action]?[x-callback parameters]&[action parameters]`
    /// - Throws: XCallbackURLFailure
    public static func xCallbackURL(
        scheme: String,
        action: Action,
        parameters: XCallbackParameters
    ) throws(XCallbackURLFailure) -> URL {
        var components = try baseURLComponents(scheme: scheme, action: action)
        if let parameters = action.parameters, !parameters.isEmpty {
            components.queryItems = (components.queryItems ?? []) + parameters
        }

        components.addQueryItems(from: parameters)

        guard let result = components.url else {
            throw .invalidURLComponents(components)
        }

        return result
    }

    private static func baseURLComponents(scheme: String, action: Action) throws(XCallbackURLFailure)
        -> URLComponents
    {
        guard scheme.isValidURLScheme else {
            throw .invalidScheme
        }

        let actionName = action.name

        var components = URLComponents()
        components.scheme = scheme
        components.host = Reserved.host
        components.path = actionName.hasPrefix("/") ? actionName : "/\(actionName)"
        return components
    }
}

extension URLComponents {
    fileprivate mutating func addQueryItems(from configuration: XCallbackParameters) {
        let namedValues: KeyValuePairs<URL.Reserved.ParameterName, String?> = [
            .source: configuration.source,
            .success: configuration.onSuccess?.url.absoluteString,
            .error: configuration.onError?.url.absoluteString,
            .cancel: configuration.onCancel?.url.absoluteString,
        ]

        var xCallbackParameters: [URLQueryItem] = namedValues.compactMap { key, value in
            guard let value = value, !value.isEmpty else {
                return nil
            }
            return URLQueryItem(name: key.rawValue, value: value)
        }

        if let queryItems {
            xCallbackParameters.append(contentsOf: queryItems)
        }

        queryItems = xCallbackParameters
    }
}
