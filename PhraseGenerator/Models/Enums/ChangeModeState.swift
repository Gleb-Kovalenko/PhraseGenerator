//
//  ChangeModeState.swift
//  PhraseGenerator
//
//  Created by Gleb Kovalenko on 27.01.2023.
//

import Foundation

// MARK: - ChangeModeState

public enum ChangeModeState {
    
    // MARK: - Cases
    
    case addGroup
    case addVariation
    case editGroup(Group)
    case editVariation(Group, Variation)
    case disable
    
    // MARK: Useful
    
    public var title: String {
        switch self {
        case .addGroup:
            return "Add new group"
        case .addVariation:
            return "Add new variation"
        case .editGroup(let group):
            return "Edit '\(group.name)' group"
        case let .editVariation(group, variation):
            return "Edit '\(variation.name)' variation in '\(group.name)' group"
        case .disable:
            return ""
        }
    }
}

// MARK: - Identifiable

extension ChangeModeState: Identifiable {
    
    public var id: String {
        switch self {
        case .addGroup:
            return "addGroup"
        case .addVariation:
            return "addVariation"
        case .editGroup(let group):
            return "editGroup-\(group.name)"
        case let .editVariation(group, variation):
            return "editVariation-\(group.name)-\(variation.name)"
        case .disable:
            return "disable"
        }
    }
}

// MARK: - Equatable

extension ChangeModeState: Equatable {
    
    public static func == (lhs: ChangeModeState, rhs: ChangeModeState) -> Bool {
        switch (lhs, rhs) {
        case (.addGroup, .addGroup), (.addVariation, .addVariation), (.disable, .disable):
            return true
        case let (.editGroup(lGroup), .editGroup(rGroup)):
            return lGroup == rGroup
        case let (.editVariation(lGroup, lVariation), .editVariation(rGroup, rVariation)):
            return lGroup == rGroup && lVariation == rVariation
        default:
            return false
        }
    }
}
