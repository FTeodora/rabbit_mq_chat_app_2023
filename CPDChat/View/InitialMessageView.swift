//
//  InitialMessageView.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/23/23.
//

import SwiftUI

struct InitialMessageView: View {
    @StateObject var viewModel: InitialMessageViewModel
    @State var message: String = ""
    @State var isDone: Bool = false
    var body: some View {
        VStack {
            Text("Your selection: ")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.leading)
            ForEach(viewModel.selectedItems) { participant in
                PersonSelectionListItem(item: participant)
            }
            Spacer()
            TextField("Type a message", text: $message )
                .lineLimit(5)
                .frame(height: 50.0)
                .background(lightGray)
                .cornerRadius(25.0)
                .padding()
            Button("DONE") {
                if case .broadcast = viewModel.mode {
                    viewModel.broadcast(message: message)
                } else {
                    viewModel.createConversation(with: message)
                }
                isDone = true
            }
            
            NavigationLink(isActive: $isDone) {
                HomeView()
            } label: {
                EmptyView()
            }
        }.navigationTitle("Your message")
    }
}

struct InitialMessageView_Previews: PreviewProvider {
    static var previews: some View {
        InitialMessageView(viewModel: InitialMessageViewModel(selectedItems: [SelectableItem(name: "user1")], mode: .person))
    }
}
