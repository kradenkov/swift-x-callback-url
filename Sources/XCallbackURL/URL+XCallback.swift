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
    ///   - action: The specific action to be executed by the target app. Cannot be empty. Must consist of URL path allowed characters
    ///   - callbacks: Configuration containing optional source app identifier and callback URLs:
    ///     - source: Identifies the source app requesting the action
    ///     - onSuccess: URL to open on successful completion
    ///     - onError: URL to open if the requested action generates an error
    ///     - onCancel: URL to open if the requested action is cancelled by the user
    ///   - parameters: Optional additional parameters specific to the action being requested
    /// - Returns: A URL conforming of following structure: `[scheme]://[host]/[action]?[x-callback parameters]&[action parameters]`
    /// - Throws: XCallbackURLFailure
    public static func xCallbackURL(
        scheme: String,
        action: String,
        callbacks: CallbacksParameters,
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

        guard !action.isEmpty && action.unicodeScalars.allSatisfy(CharacterSet.urlPathAllowed.contains)
        else {
            throw .invalidAction(action)
        }

        var components = URLComponents()
        components.scheme = scheme
        components.host = Reserved.host
        components.path = action.hasPrefix("/") ? action : "/\(action)"
        return components
    }
}

extension URLComponents {
    fileprivate mutating func addQueryItems(from configuration: CallbacksParameters) {
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

        self.queryItems = xCallbackParameters
    }
}
