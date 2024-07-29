//
//  ContentView.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/18/23.
//

import SwiftUI

struct ContentView: View {
    @State var username: String = ""
    @State var isLoggedIn: Bool = false
    @State var connecting = false
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    VStack {
                        Image(systemName: "message.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .padding()
                        TextField("Username", text: $username)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(30)
                            .padding(.vertical)
                        ZStack {
                            NavigationLink(destination: HomeView(), isActive: $isLoggedIn) {
                                EmptyView()
                            }
                            
                            Button("Login") {
                                connecting = true
                                RabbitService.shared.connect {
                                    SessionHandler.shared.startSession(with: username)
                                    connecting = false
                                    isLoggedIn = true
                                }
                            }.padding()
                            .frame(maxWidth: .infinity)
                            .background(.teal)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        }
                    }.padding(30)
                    .background(.blue)
                    .cornerRadius(20)
                    .padding(20.0)
                    Spacer()
                }
                if connecting {
                    ZStack {
                        Color.black.opacity(0.2)
                        ProgressView()
                    }.ignoresSafeArea()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
