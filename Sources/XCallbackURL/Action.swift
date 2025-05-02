//
//  Action.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 29.04.2025.
//

import Foundation

/// Represents an action to be executed by the target app in an x-callback-url.
/// An action consists of a name and optional parameters that will be included in the URL.
public struct Action: Sendable {
    /// The name of the action to be executed. Must be a valid URL path component.
    let name: String

    /// Optional parameters specific to this action that will be included as query items in the URL.
    /// Parameter names must not start with "x-" as this prefix is reserved for x-callback-url parameters.
    let parameters: [URLQueryItem]?

    /// Creates a new action with the specified name and optional parameters.
    /// - Parameters:
    ///   - name: The name of the action. Must not be empty and must only contain valid URL path characters.
    ///   - parameters: Optional array of URL query items specific to this action. Parameter names must not start with "x-"
    ///                 as this prefix is reserved for x-callback-url parameters.
    /// - Throws: `XCallbackURLFailure.invalidAction` if the name is empty or contains invalid URL path characters.
    ///          `XCallbackURLFailure.denyedParamareterNames` if any parameter name starts with "x-".
    public init(name: String, parameters: [URLQueryItem]? = nil) throws(XCallbackURLFailure) {
        guard !name.isEmpty && name.unicodeScalars.allSatisfy(CharacterSet.urlPathAllowed.contains) else {
            throw .invalidAction(name)
        }

        if let invalidParameters: [URLQueryItem] = parameters?.filter({
            $0.name.hasPrefix(URL.Reserved.parameterPrefix)
        }), !invalidParameters.isEmpty {
            throw .denyedParamareterNames(invalidParameters.map(\.name))
        }
        self.name = name
        self.parameters = parameters
    }
}
