//
//  NewConversationView.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/22/23.
//

import SwiftUI

struct NewConversationView: View {
    var body: some View {
        VStack {
            List {
                Spacer()
                ForEach(options) { option in
                    OptionListItem(viewModel: option)
                        .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .listRowSeparator(.hidden)
                }
            }.listStyle(.plain)
        }.navigationTitle("New conversation")
    }
    
    var options: [OptionListItemViewModel] = [
        OptionListItemViewModel(type: .person, title: "Message person", description: "Send a message to a single person"),
        OptionListItemViewModel(type: .group, title: "Group", description: "Create a new group chat with multiple people"),
        OptionListItemViewModel(type: .broadcast, title: "Broadcast", description: "Send a message to multiple existing conversations")
    ]
}

struct NewConversationView_Previews: PreviewProvider {
    static var previews: some View {
        NewConversationView()
    }
}
