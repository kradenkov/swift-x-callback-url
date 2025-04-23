//
//  StringProtocol+ExtensionTests.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 25.04.2025.
//

import Foundation
import Testing

@testable import XCallbackURL

@Suite("StringProtocol+Extension") struct StringProtocolExtensionTests {
  private enum TestData {
    static let scheme = "x-callback-url"
    static let host = "localhost.localdomain"
  }

  @Test("asciiLetters") func testASCIILetters() throws {
    #expect(
      CharacterSet.asciiLetters
        == CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))
    #expect(CharacterSet.asciiLetters.isSubset(of: .ascii))
  }

  @Test("urlSchemeAllowed") func testURLSchemeAllowed() throws {
    #expect(!CharacterSet.urlSchemeAllowed.isDisjoint(with: .ascii))
    #expect(CharacterSet.urlSchemeAllowed.isSuperset(of: .asciiLetters))
    #expect(CharacterSet.urlSchemeAllowed.isSuperset(of: .decimalDigits))
    #expect(CharacterSet.urlSchemeAllowed.isSuperset(of: CharacterSet(charactersIn: "+.-")))
  }

  @Test("isValidURLScheme") func testIsValidURLScheme() throws {
    // Valid schemes
    #expect("scheme".isValidURLScheme)
    #expect("s".isValidURLScheme)
    #expect("scheme+1.2-3".isValidURLScheme)
    #expect("x-callback-url".isValidURLScheme)
    #expect("myApp.callback".isValidURLScheme)
    #expect("myApp+callback".isValidURLScheme)

    // Invalid schemes
    #expect(!"".isValidURLScheme)  // Empty string
    #expect(!"1".isValidURLScheme)  // Contains only number
    #expect(!"1scheme".isValidURLScheme)  // Starts with number
    #expect(!"1scheme".isValidURLScheme)  // Starts with number
    #expect(!".scheme".isValidURLScheme)  // Starts with symbol
    #expect(!"-scheme".isValidURLScheme)  // Starts with symbol
    #expect(!"+scheme".isValidURLScheme)  // Starts with symbol
    #expect(!"scheme space".isValidURLScheme)  // Contains space
    #expect(!" ".isValidURLScheme)  // Contains only space
    #expect(!"scheme#".isValidURLScheme)  // Contains invalid character
    #expect(!"scheme?".isValidURLScheme)  // Contains invalid character
    #expect(!"scheme/".isValidURLScheme)  // Contains invalid character
    #expect(!"схема".isValidURLScheme)  // Non-ASCII characters
  }
}
