//
//  ConversationListItem.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/20/23.
//

import SwiftUI

struct ConversationListItem: View {
    var conversation: Conversation
    var body: some View {
        HStack {
            conversation.type.icon
                .resizable()
                .frame(width: 50)
                .scaledToFit()
                
            Text(conversation.name ?? "Conversation")
                .font(.headline)
            Spacer()
        }.frame(maxWidth: .infinity)
        .padding()
    }
}
