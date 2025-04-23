//
//  CallbackTests.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 23.04.2025.
//

import Foundation
import Testing

@testable import XCallbackURL

@Suite("Callback URL") struct CallbackTests {
  private enum TestData {
    static let scheme = "x-callback-url"
    static let host = "localhost.localdomain"
  }

  @Test("valid URL")
  func validURL() throws {
    var components = URLComponents()
    components.scheme = TestData.scheme
    components.host = TestData.host

    let url = try #require(components.url)
    #expect(url.scheme == TestData.scheme)
    #expect(url.host == TestData.host)

    let callback = try Callback(url: url)
    #expect(callback.url == url)
  }

  @Test("init with missing scheme in URL should fail")
  func missingSchemeURL() throws {
    var components = URLComponents()
    components.host = TestData.host

    let url = try #require(components.url)
    #expect(url.scheme == nil)
    #expect(url.host == TestData.host)
    #expect(url.absoluteString == "//localhost.localdomain")
    #expect(
      throws: Callback.InconsistencyReason.missingScheme, performing: { try Callback(url: url) })
  }

  @Test("init with missing host in URL should fail")
  func emptyHostURL() throws {
    var components = URLComponents()
    components.scheme = TestData.scheme

    let url = try #require(components.url)
    #expect(url.scheme == TestData.scheme)
    #expect(url.host == nil)

    #expect(throws: Callback.InconsistencyReason.missingHost) { try Callback(url: url) }
  }
}
