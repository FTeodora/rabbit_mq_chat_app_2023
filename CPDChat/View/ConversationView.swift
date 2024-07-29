//
//  ConversationView.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/20/23.
//

import SwiftUI

struct ConversationView: View {
    @StateObject var viewModel: ConversationViewModel
    @State var currMessage: String = ""
    @State var disableText: Bool = true
    
    var isGroup: Bool {
        if case .group = viewModel.conversation.type {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    ForEach(viewModel.messages) { message in
                        MessageListItem(message: message, isGroup: isGroup)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    }.onChange(of: viewModel.messages.count) { _ in
                        value.scrollTo(viewModel.messages.count - 1)
                    }
                }
            }
            
            HStack {
                TextField("Message", text: $currMessage)
                    .padding()
                    .background(.white)
                    .frame(height: 40.0)
                    .cornerRadius(20.0)
                    .disabled(disableText)
                    .autocorrectionDisabled()
                    .onTapGesture {
                        disableText = false
                    }
                Button {
                    disableText = true
                    viewModel.send(message: currMessage)
                    currMessage = ""
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                }

            }.padding()
            .background(lightGray)
                
        }.navigationTitle(viewModel.conversation.name ?? "Conversation")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMessages()
        }
    }
}
