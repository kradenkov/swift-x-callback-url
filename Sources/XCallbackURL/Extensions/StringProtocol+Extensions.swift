//
//  StringProtocol+Extensions.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 25.04.2025.
//
import Foundation

extension StringProtocol {
    /// Determines if content represents valid URL Scheme
    /// - Note: Scheme names are case sensitive, must start with an ASCII letter, and may contain only ASCII letters, numbers, the “+” character, the “-” character, and the “.” character.
    var isValidURLScheme: Bool {
        guard !isEmpty else { return false }

        guard let first, first.unicodeScalars.allSatisfy(CharacterSet.asciiLetters.contains) else {
            return false
        }

        let nextIndex = index(after: startIndex)
        guard nextIndex < endIndex else { return true }

        return suffix(from: nextIndex).allSatisfy {
            $0.unicodeScalars.allSatisfy(CharacterSet.urlSchemeAllowed.contains)
        }
    }
}
