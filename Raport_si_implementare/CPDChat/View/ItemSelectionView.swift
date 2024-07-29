//
//  ItemSelectionView.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/22/23.
//

import SwiftUI

struct ItemSelectionView: View {
    @StateObject var viewModel: ItemSelectionViewModel
    @State var isDone = false
    
    var singleSelection: Bool {
        if case .person = viewModel.type {
            return true
        }
        return false
    }
    
    var broadcasting: Bool {
        if case .broadcast = viewModel.type {
            return true
        }
        return false
    }
    
    init(type: ConversationType) {
        _viewModel = StateObject(wrappedValue: ItemSelectionViewModel(type: type))
    }
    var body: some View {
        VStack {
            Spacer()
            ForEach(viewModel.items) { user in
                PersonSelectionListItem(item: user, isSelectable: !singleSelection) {
                    if singleSelection {
                        isDone = true
                    }
                }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            Spacer()
            if !singleSelection {
                Button("Done") {
                    isDone = true
                }.padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .foregroundColor(.white)
            }
            NavigationLink(destination: InitialMessageView(viewModel: InitialMessageViewModel(selectedItems: viewModel.selectedItems, mode: viewModel.type)), isActive: $isDone) { EmptyView() }
        }.navigationTitle("\(broadcasting ? "Conversations" : "People") selection")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if broadcasting {
                await viewModel.fetchConversations()
            } else {
                await viewModel.fetchUsers()
            }
        }
    }
}

struct UserSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ItemSelectionView(type: .group)
    }
}
