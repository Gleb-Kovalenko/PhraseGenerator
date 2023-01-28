//
//  ChangeGroupView.swift
//  PhraseGenerator
//
//  Created by Gleb Kovalenko on 27.01.2023.
//

import Foundation
import SwiftUI

// MARK: - ChangeGroupView

public struct ChangeGroupView: View {
    
    // MARK: - Properties
    
    @Binding var groups: [Group]
    @Binding var changeModeState: ChangeModeState
    @State private var errorMessage: ErrorMessage? = nil
    @State private var newVariationName = ""
    @State private var newVariationProbability = ""
    @State private var newGroupName = ""
    
    public init(groups: Binding<[Group]>, changeModeState: Binding<ChangeModeState>) {
        self._groups = groups
        self._changeModeState = changeModeState
        
        switch self.changeModeState {
        case .editGroup(let group):
            _newGroupName = State(initialValue: group.name)
        case let .editVariation(group, variation):
            _newGroupName = State(initialValue: group.name)
            _newVariationName = State(initialValue: variation.name)
            _newVariationProbability = State(initialValue: "\(variation.probabilty)")
        default:
            return
        }
    }
    
    // MARK: - Private
    
    private func changeVariation(_ group: Group? = nil, _ variation: Variation? = nil) {
        
        if newGroupName.isEmpty {
            errorMessage = ErrorMessage(text: "Empty group name")
            return
        }
        newGroupName = newGroupName.trimmingCharacters(in: .whitespaces)
        newVariationProbability = newVariationProbability.replacingOccurrences(of: ",", with: ".")
        guard let groupIndex = groups.firstIndex(where: { $0.name == newGroupName}) else {
            errorMessage = ErrorMessage(text: "Wrong group name")
            return
        }
        guard let probabiltyNumber = Double(newVariationProbability) else {
            errorMessage = ErrorMessage(text: "Incorrect number")
            return
        }
        if probabiltyNumber < 0 || probabiltyNumber > 1 {
            errorMessage = ErrorMessage(text: "Probabilty number must be between 0 and 1")
            return
        }
        if groups[groupIndex].variations.contains(where: { $0.name == newVariationName }) {
            errorMessage = ErrorMessage(text: "This variation name in this group is taken")
            return
        }
        if let variation = variation, let group = group, let oldGroupIndex = groups.firstIndex(of: group) {
            if let variationIndex = groups[groupIndex].variations.firstIndex(of: variation) {
                groups[groupIndex].variations[variationIndex] = Variation(name: newVariationName, probabilty: probabiltyNumber)
            } else {
                groups[oldGroupIndex].variations.removeAll(where: { $0.name == variation.name })
                groups[groupIndex].variations.append(
                    Variation(name: newVariationName, probabilty: probabiltyNumber)
                )
            }
        } else {
            groups[groupIndex].variations.append(
                Variation(name: newVariationName, probabilty: probabiltyNumber)
            )
        }
        changeModeState = .disable
    }
    
    private func changeGroup(_ group: Group? = nil) {
        
        if !isCorrectGroupName() {
            return
        }
        newGroupName = newGroupName.trimmingCharacters(in: .whitespaces)
        if let group = group,
           let index = groups.firstIndex(of: group) {
            groups[index] = Group(name: newGroupName, variations: group.variations)
        } else {
            groups.append(Group(name: newGroupName, variations: []))
        }
        changeModeState = .disable
    }
    
    private func isCorrectGroupName() -> Bool {
        
        if newGroupName.isEmpty {
            errorMessage = ErrorMessage(text: "Empty group name")
            return false
        }
        if groups.contains(where: { $0.name == newGroupName }) {
            errorMessage = ErrorMessage(text: "This group name is taken")
            return false
        }
        return true
    }
    
    // MARK: - View
    
    public var body: some View {
        VStack(spacing: Constants.changeGroupViewSpacing) {
            Text(changeModeState.title)
            TextField("Group name", text: $newGroupName)
            switch changeModeState {
            case .addVariation, .editVariation:
                TextField("Variation name", text: $newVariationName)
                TextField("Variation probabilty", text: $newVariationProbability)
                    .keyboardType(.decimalPad)
            default:
                EmptyView()
            }
            HStack {
                Spacer()
                Button(action:  {
                    switch changeModeState {
                    case .addGroup:
                        changeGroup()
                    case .addVariation:
                        changeVariation()
                    case .editGroup(let group):
                        changeGroup(group)
                    case .editVariation(let group, let variation):
                        changeVariation(group,variation)
                    case .disable:
                        return
                    }
                }) {
                    Text("Confirm")
                }
                Spacer()
            }.alert(item: $errorMessage) { message in
                Alert(
                    title: Text(message.text),
                    dismissButton: .cancel()
                )
            }
        }
        .padding()
    }
}

// MARK: - Constants

private enum Constants {
    static let changeGroupViewSpacing: CGFloat = 24
}

// MARK: - Preview

struct ChangeGroupView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = [
            Group(name: "Color", variations: [
                Variation(name: "Green", probabilty: 0.3),
                Variation(name: "Red", probabilty: 0.4),
                Variation(name: "Black", probabilty: 0.3)
            ]),
            Group(name: "Style", variations: [
                Variation(name: "Van Gog", probabilty: 0.2),
                Variation(name: "Realism", probabilty: 0.45),
                Variation(name: "Futurism", probabilty: 0.35)
            ]),
        ]
        ChangeGroupView(groups: .constant(groups), changeModeState: .constant(.editGroup(groups[0])))
    }
}
