//
//  MessageListItem.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/20/23.
//

import SwiftUI

struct MessageListItem: View {
    var message: Message
    
    var isAuthor: Bool {
        SessionHandler.shared.user?.name == message.author
    }
    var isGroup: Bool = false
    var body: some View {
        HStack {
            if isAuthor {
                Spacer()
            }
            VStack(alignment: isAuthor ? .trailing : .leading) {
                if(!isAuthor && isGroup) {
                    Text(message.author)
                        .font(.callout)
                        .padding(0)
                    }
                Text(message.content)
                    .foregroundColor(.white)
                    .padding()
                    .background(isAuthor ? .blue: .gray)
                    .cornerRadius(8)
            }
            if !isAuthor {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 8)
    }
}

struct MessageListItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageListItem(message: Message(content: "Hey", author: "user1"), isGroup: true)
            MessageListItem(message: Message(content: "I've come to talk to u again", author: "user2"))
        }.listStyle(.plain)
    }
}
