//
//  CallbacksConfigurationTests.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 23.04.2025.
//

import Foundation
import Testing

@testable import XCallbackURL

@Suite("Callbacks Configuration") struct CallbacksConfigurationTests {
  @Test("init with onSuccess callback") func successCallback() throws {
    let url = try #require(URL(string: "foo://success"))
    let sut = try CallbacksConfiguration(onSuccess: Callback(url: url))
    #expect(sut.source == nil)
    #expect(sut.onSuccess?.url == url)
    #expect(sut.onError == nil)
    #expect(sut.onCancel == nil)
  }

  @Test("init with onError callback") func errorCallback() throws {
    let url = try #require(URL(string: "foo://failure"))
    let sut = try CallbacksConfiguration(onError: Callback(url: url))
    #expect(sut.source == nil)
    #expect(sut.onSuccess == nil)
    #expect(sut.onError?.url == url)
    #expect(sut.onCancel == nil)
  }

  @Test("init with onCancel callback") func cancellCallback() throws {
    let url = try #require(URL(string: "foo://cancel"))
    let sut = try CallbacksConfiguration(onCancel: Callback(url: url))
    #expect(sut.source == nil)
    #expect(sut.onSuccess == nil)
    #expect(sut.onError == nil)
    #expect(sut.onCancel?.url == url)
  }

  @Test("init with all parameters") func fullPayloadCallback() throws {
    let successURL = try #require(URL(string: "foo://success"))
    let errorURL = try #require(URL(string: "bar://failure"))
    let cancelURL = try #require(URL(string: "buzz://cancel"))
    let sut = try CallbacksConfiguration(
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

  @Test("init with no callbacks should fail") func missingCallbacks() throws {
    #expect(throws: CallbacksConfiguration.InconsistencyReason.atLeastOneCallbackRequired) {
      try CallbacksConfiguration(source: "foo")
    }
  }
}
