//
//  Key.swift
//  ©️ 2023 0100
//

import Foundation

enum Key: String, CaseIterable {
    case A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
    case ENTER
    case DELETE
    case __
    
    init?(rawValue: String) {
        guard let match = Self.allCases.first(where: {
            // Uppercase parameter before initializing
            $0.rawValue == rawValue.uppercased()
        }) else {
            return nil
        }
        
        self = match
    }
}
