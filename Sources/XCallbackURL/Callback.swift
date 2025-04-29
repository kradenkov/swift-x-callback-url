//
//  Callback.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 23.04.2025.
//

import Foundation

public struct Callback: Sendable {
    public enum InconsistencyReason: Error {
        case missingScheme
        case missingHost
    }

    let url: URL

    public init(url: URL) throws(InconsistencyReason) {
        guard let scheme = url.scheme, !scheme.isEmpty else {
            throw InconsistencyReason.missingScheme
        }

        guard let host = url.host(), !host.isEmpty else {
            throw InconsistencyReason.missingHost
        }

        self.url = url
    }
}
