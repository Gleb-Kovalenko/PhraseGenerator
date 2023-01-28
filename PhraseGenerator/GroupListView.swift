//
//  GroupListView.swift
//  PhraseGenerator
//
//  Created by Gleb Kovalenko on 27.01.2023.
//

import SwiftUI

// MARK: - GroupListView

public struct GroupListView: View {
    
    // MARK: - Properties
    
    @State var groups = [Group]()
    @State private var changeModeState: ChangeModeState = .disable
    @State private var showConfirmationGroupDelete = false
    
    // MARK: - Private
    
    private func deleteGroup(_ group: Group) {
        groups.removeAll(where: { $0.name == group.name })
    }
    
    private func deleteVariation(at indexSet: IndexSet, in group: Group) {
        guard let groupIndex = groups.firstIndex(of: group) else {
            return
        }
        groups[groupIndex].variations.remove(atOffsets: indexSet)
    }
    
    // MARK: - View
    
    public var body: some View {
        NavigationView {
            List {
                ForEach(groups, id: \.name) { group in
                    Section(header:
                                HStack(spacing: Constants.sectionHeaderSpacing) {
                            Text(group.name)
                            Spacer()
                            Button(action: {
                                changeModeState = .editGroup(group)
                            }) {
                                Image(systemName: "pencil")
                            }
                            Button(action: {
                                showConfirmationGroupDelete = true
                            }) {
                                Image(systemName: "trash")
                            }
                            .confirmationDialog("Are you sure?", isPresented: $showConfirmationGroupDelete) {
                                Button("Confirm") {
                                    deleteGroup(group)
                                    showConfirmationGroupDelete = false
                                }
                            }
                            .padding(.trailing, Constants.deleteButtonTraillingPadding)
                        }
                    ) {
                        ForEach(group.variations, id: \.self) { variation in
                            Button(action: {
                                changeModeState = .editVariation(group, variation)
                            }) {
                                HStack {
                                    Text(variation.name)
                                    Spacer()
                                    Text("\(variation.probabilty * 100, specifier: "%.2f")%")
                                }
                            }
                        }
                        .onDelete { self.deleteVariation(at: $0, in: group) }
                    }
                }
            }
            .navigationBarTitle(Text("Phrase Generator"))
            .navigationBarHidden(false)
            .navigationBarItems(trailing:
                Menu {
                    Button(action: {
                        changeModeState = .addGroup
                    }) {
                        Label("Add group", systemImage: "plus.circle")
                    }
                    Button(action: {
                        changeModeState = .addVariation
                    }) {
                        Label("Add variation", systemImage: "plus.circle")
                    }
                } label: {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: .init(
                    get: { changeModeState != .disable },
                    set: { _ in changeModeState = .disable }
                )
            ) {
                ChangeGroupView.init(groups: $groups, changeModeState: $changeModeState)
            }
        }
    }
}

// MARK: - Constants

private enum Constants {
    static let sectionHeaderSpacing: CGFloat = 18
    static let deleteButtonTraillingPadding: CGFloat = 8
}

// MARK: - Preview

struct GroupListView_Previews: PreviewProvider {
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
        GroupListView(groups: groups)
    }
}
