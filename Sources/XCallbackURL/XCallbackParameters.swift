//
//  XCallbackParameters.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 23.04.2025.
//

public struct XCallbackParameters {
    let source: String?
    let onSuccess: Callback?
    let onError: Callback?
    let onCancel: Callback?

    public init(
        source: String? = nil,
        onSuccess: Callback? = nil,
        onError: Callback? = nil,
        onCancel: Callback? = nil
    ) {
        self.source = source
        self.onSuccess = onSuccess
        self.onError = onError
        self.onCancel = onCancel
    }
}
