//
//  URL+XCallbackTests.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 28.04.2025.
//
import Foundation
import Testing

@testable import XCallbackURL

@Suite("URL+XCallbackTests") struct URLXCallbackTests {
  private enum TestData {
    static let scheme = "x-callback-scheme"
    static let action = "action"
    static let source = "source-value"
    static let successCallbackURL: Callback = try! Callback(url: URL(string: "foo://success-host")!)
    static let failureCallbackURL: Callback = try! Callback(url: URL(string: "bar://error-host")!)
    static let cancelCallbackURL: Callback = try! Callback(url: URL(string: "buzz://cancel-host")!)
  }

  @Test("x-callback parameters should preseed action parameters")
  func testActionWithAllCallbacksAndSource() throws {
    let xcallbackURL = try URL.xCallbackURL(
      scheme: TestData.scheme,
      action: TestData.action,
      callbacks: CallbacksConfiguration(
        source: TestData.source,
        onSuccess: TestData.successCallbackURL,
        onError: TestData.failureCallbackURL,
        onCancel: TestData.cancelCallbackURL
      ),
      parameters: [URLQueryItem(name: "param1", value: "value1")]
    )

    #expect(
      xcallbackURL
        == URL(
          string:
            "x-callback-scheme://x-callback-url/action?x-source=source-value&x-success=foo://success-host&x-error=bar://error-host&x-cancel=buzz://cancel-host&param1=value1"
        ))
  }

  @Test("action with cancellation callback only") func testCancellableActionXCallbackURL() throws {
    let xcallbackURL = try URL.xCallbackURL(
      scheme: TestData.scheme,
      action: TestData.action,
      callbacks: CallbacksConfiguration(onCancel: TestData.cancelCallbackURL)
    )

    #expect(
      xcallbackURL
        == URL(
          string:
            "\(TestData.scheme)://\(URL.Reserved.host)/\(TestData.action)?x-cancel=\(TestData.cancelCallbackURL.url)"
        ))
  }

  @Test("action with cancellation callback and parameters")
  func testCancellableActionXCallbackURLwithParameters() throws {
    let xcallbackURL = try URL.xCallbackURL(
      scheme: TestData.scheme,
      action: TestData.action,
      callbacks: CallbacksConfiguration(onCancel: TestData.cancelCallbackURL),
      parameters: [URLQueryItem(name: "param1", value: "value1")]
    )

    #expect(
      xcallbackURL
        == URL(
          string:
            "\(TestData.scheme)://\(URL.Reserved.host)/\(TestData.action)?x-cancel=\(TestData.cancelCallbackURL.url)&param1=value1"
        ))
  }

  @Test("empty action with cancellation callback should fail") func testEmptyAction() throws {
    #expect(throws: XCallbackURLFailure.invalidAction("")) {
      try URL.xCallbackURL(
        scheme: TestData.scheme,
        action: "",
        callbacks: CallbacksConfiguration(onCancel: TestData.cancelCallbackURL)
      )
    }
  }
  
  @Test("action containing invalid URL path Characters should fail") func testInvalidActionCharacters() throws {
    #expect(throws: XCallbackURLFailure.invalidAction("action#withInvalidCharacter")) {
      try URL.xCallbackURL(
        scheme: TestData.scheme,
        action: "action#withInvalidCharacter",
        callbacks: CallbacksConfiguration(onCancel: TestData.cancelCallbackURL)
      )
    }
  }

  @Test("empty scheme should throw") func testEmptyScheme() throws {
    #expect(throws: XCallbackURLFailure.invalidScheme) {
      try URL.xCallbackURL(
        scheme: "",
        action: TestData.action,
        callbacks: CallbacksConfiguration(onCancel: TestData.cancelCallbackURL)
      )
    }
  }

  @Test("action prefixed by slash") func testSlashedAction() throws {
    let xcallbackURL = try URL.xCallbackURL(
      scheme: TestData.scheme,
      action: "/" + TestData.action,
      callbacks: CallbacksConfiguration(onCancel: TestData.cancelCallbackURL)
    )

    #expect(
      xcallbackURL
        == URL(
          string:
            "\(TestData.scheme)://\(URL.Reserved.host)/\(TestData.action)?x-cancel=\(TestData.cancelCallbackURL.url)"
        ))
  }

  @Test("denied parameter name should fail") func testDeniedParameterNames() throws {
    #expect(throws: XCallbackURLFailure.denyedParamareterNames(["x-param1", "x-param3"])) {
      try URL.xCallbackURL(
        scheme: TestData.scheme,
        action: TestData.action,
        callbacks: CallbacksConfiguration(onCancel: TestData.cancelCallbackURL),
        parameters: [
          URLQueryItem(name: "x-param1", value: "value1"),
          URLQueryItem(name: "param2", value: "value2"),
          URLQueryItem(name: "x-param3", value: "value3"),
        ]
      )
    }
  }
}
