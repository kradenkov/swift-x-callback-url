//
//  CharacterSet+Extensions.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 25.04.2025.
//
import Foundation

extension CharacterSet {
  static let ascii: CharacterSet = CharacterSet(
    charactersIn: Unicode.Scalar(0)...Unicode.Scalar(127))
  static let asciiLetters: CharacterSet = CharacterSet(charactersIn: "A"..."Z")
    .union(CharacterSet(charactersIn: "a"..."z"))
  static let urlSchemeAllowed: CharacterSet = CharacterSet.asciiLetters
    .union(.decimalDigits)
    .union(CharacterSet(charactersIn: "+-."))
}
