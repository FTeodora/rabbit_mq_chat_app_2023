//
//  HomeView.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/21/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    var body: some View {
        VStack {
            HStack {
                Spacer()
                NavigationLink {
                    NewConversationView()
                } label: {
                    Image(systemName: "plus.bubble")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30.0)
                }
            }.padding()
            .frame(maxWidth: .infinity)
            .background(lightGray)
            ForEach(viewModel.conversations) { conversation in
                NavigationLink {
                    ConversationView(viewModel: ConversationViewModel(conversation: conversation))
                } label: {
                    ConversationListItem(conversation: conversation)
                }
            }
            Spacer()
        }.navigationTitle(SessionHandler.shared.user?.name ?? "")
        .navigationBarBackButtonHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
