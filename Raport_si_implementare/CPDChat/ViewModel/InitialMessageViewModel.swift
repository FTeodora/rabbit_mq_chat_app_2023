//
//  InitialMessageViewModel.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/23/23.
//

import Foundation
import Combine

class InitialMessageViewModel: ObservableObject {
    var mode: ConversationType
    var selectedItems: [SelectableItem]
    var publisher: RabbitPublisher<Message>?
    
    init(selectedItems: [SelectableItem], mode: ConversationType) {
        self.selectedItems = selectedItems
        self.mode = mode
        if case mode = ConversationType.broadcast {
            publisher = RabbitPublisher(connection: ConversationConnection())
        }
    }
    
    func broadcast(message: String) {
        guard let session = SessionHandler.shared.user?.name,
                let db = SessionHandler.shared.db else { return }
        selectedItems.forEach { conversation in
            guard let id = conversation.hiddenField else { return }
            let message = Message(content: message, author: session, conversation: id )
            do {
                try message.add(to: db)
            } catch (let error) {
                print("Failed to add message to database: \(error)")
            }
            publisher?.send(message: message, on: conversation.name.replacingOccurrences(of: ",", with: "."))
        }
    }
    
    func createConversation(with message: String) {
        guard let session = SessionHandler.shared.user?.name, let db = SessionHandler.shared.db else { return }
        var users = selectedItems.compactMap { $0.name }
        users.append(session)
        let id = UUID().uuidString
        let conversation = Conversation(id: id, type: mode)
        do {
            try conversation.add(to: db, with: users, and: Message(id: UUID().uuidString, content: message, author: session, conversation: id))
        } catch(let error) {
            print("Failed to add conversation to firestore: \(error.localizedDescription)")
        }
        print("Conversation created")
    }
}
