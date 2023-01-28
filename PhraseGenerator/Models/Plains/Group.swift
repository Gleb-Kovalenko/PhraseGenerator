//
//  Group.swift
//  PhraseGenerator
//
//  Created by Gleb Kovalenko on 27.01.2023.
//

import Foundation

// MARK: - Group

public struct Group: Hashable {
    
    // MARK: - Properties
    
    public var name: String
    public var variations: [Variation]
}
