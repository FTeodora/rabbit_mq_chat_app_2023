//
//  PersonSelectionListItem.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/22/23.
//

import SwiftUI

struct PersonSelectionListItem: View {
    @ObservedObject var item: SelectableItem
    var isSelectable: Bool = false
    var onTap: ()->() = {}
    var body: some View {
        HStack {
            if isSelectable {
                Image(systemName: item.isSelected ? "checkmark.circle.fill" : "circle")
            }
            Text(item.name)
            Spacer()
        }.padding()
        .frame(maxWidth: .infinity)
        .background(item.isSelected&&isSelectable ? .green : .white)
        .foregroundColor(item.isSelected&&isSelectable ? .white : .black)
        .onTapGesture {
            item.isSelected = !item.isSelected
            onTap()
        }
    }
}

struct PersonSelectionListItem_Previews: PreviewProvider {
    static var previews: some View {
        PersonSelectionListItem(item: SelectableItem(name: "User1"), isSelectable: true)
    }
}
