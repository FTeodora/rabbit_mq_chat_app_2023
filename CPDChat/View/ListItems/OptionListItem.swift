//
//  OptionListItem.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/22/23.
//

import SwiftUI

struct OptionListItemViewModel: Identifiable {
    var type: ConversationType
    var title: String
    var description: String?
    var id: ConversationType {
        type
    }
}

struct OptionListItem: View {
    var viewModel: OptionListItemViewModel
    var body: some View {
        ZStack {
            NavigationLink {
                ItemSelectionView(type: viewModel.type)
            } label: {
                EmptyView()
            }

            HStack {
                viewModel.type.icon
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 50)
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.headline)
                    if let description = viewModel.description {
                        Text(description)
                            .font(.subheadline)
                    } else {
                        Spacer()
                    }
                }.frame(maxWidth: .infinity)
                Spacer()
            }.frame(maxWidth: .infinity)
            .padding()
            .background(.blue)
            .cornerRadius(20.0)
            .padding(.horizontal, 10.0)
            .foregroundColor(.white)
        }
    }
}

struct OptionListItem_Previews: PreviewProvider {
    static var previews: some View {
        OptionListItem(viewModel: OptionListItemViewModel(type: .group , title: "Group chat", description: "Create a chat with multiple people"))
    }
}
