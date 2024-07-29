//
//  HomeViewModel.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/21/23.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor
class HomeViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    init() {
        listenForConversations()
    }
    
    func listenForConversations() {
        guard let db = SessionHandler.shared.db,
        let session = SessionHandler.shared.user?.name else { return }
        Conversation.listen(to: db, for: session) { [weak self] documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print(error?.localizedDescription)
                return
            }
            self?.conversations = documentSnapshot.documents.compactMap { try? $0.data(as: Conversation.self, decoder: Firestore.Decoder()) }
        }
    }
}
