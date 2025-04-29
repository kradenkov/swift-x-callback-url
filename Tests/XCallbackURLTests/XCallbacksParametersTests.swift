//
//  CallbacksConfigurationTests.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 23.04.2025.
//

import Foundation
import Testing

@testable import XCallbackURL

@Suite("XCallbacks Parameters") struct XCallbacksParametersTests {
    @Test("init with onSuccess callback") func successCallback() throws {
        let url = try #require(URL(string: "foo://success"))
        let sut = try XCallbackParameters(onSuccess: Callback(url: url))
        #expect(sut.source == nil)
        #expect(sut.onSuccess?.url == url)
        #expect(sut.onError == nil)
        #expect(sut.onCancel == nil)
    }

    @Test("init with onError callback") func errorCallback() throws {
        let url = try #require(URL(string: "foo://failure"))
        let sut = try XCallbackParameters(onError: Callback(url: url))
        #expect(sut.source == nil)
        #expect(sut.onSuccess == nil)
        #expect(sut.onError?.url == url)
        #expect(sut.onCancel == nil)
    }

    @Test("init with onCancel callback") func cancellCallback() throws {
        let url = try #require(URL(string: "foo://cancel"))
        let sut = try XCallbackParameters(onCancel: Callback(url: url))
        #expect(sut.source == nil)
        #expect(sut.onSuccess == nil)
        #expect(sut.onError == nil)
        #expect(sut.onCancel?.url == url)
    }

    @Test("init with all parameters") func fullPayloadCallback() throws {
        let successURL = try #require(URL(string: "foo://success"))
        let errorURL = try #require(URL(string: "bar://failure"))
        let cancelURL = try #require(URL(string: "buzz://cancel"))
        let sut = try XCallbackParameters(
            source: "",
            onSuccess: Callback(url: successURL),
            onError: Callback(url: errorURL),
            onCancel: Callback(url: cancelURL)
        )
        #expect(sut.source == "")
        #expect(sut.onSuccess?.url == successURL)
        #expect(sut.onError?.url == errorURL)
        #expect(sut.onCancel?.url == cancelURL)
    }

    @Test("init with a source") func missingCallbacks() throws {
        let parameters: XCallbackParameters = try XCallbackParameters(source: "foo")
        #expect(parameters.source == "foo")
        #expect(parameters.onSuccess == nil)
        #expect(parameters.onError == nil)
        #expect(parameters.onCancel == nil)
    }
}
