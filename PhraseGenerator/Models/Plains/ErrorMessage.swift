//
//  ErrorMessage.swift
//  PhraseGenerator
//
//  Created by Gleb Kovalenko on 27.01.2023.
//

import Foundation

// MARK: - ErrorMessage

public struct ErrorMessage: Identifiable {
    
    // MARK: - Properties
    
    public let id = UUID()
    public var text: String
}
