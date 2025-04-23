//
//  Failure.swift
//  XCallbackURL
//
//  Created by Oleksandr Kradenkov on 25.04.2025.
//

import Foundation

public enum XCallbackURLFailure: Error, Equatable {
  case invalidScheme
  case emptyAction
  case denyedParamareterNames([String])
  case invalidURLComponents(URLComponents)
}
