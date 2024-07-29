//
//  ConversationViewModel.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/20/23.
//

import Foundation
import Combine

class ConversationViewModel: ObservableObject {
    var rabbitProducer: RabbitPublisher<Message>?
    var rabbitListener: RabbitListener<Message>?
    var subscribers = Set<AnyCancellable>()
    var connection: ConversationConnection?
    var routingKey: String?
    @Published var conversation: Conversation
    @Published var messages: [Message] = []
    init(conversation: Conversation) {
        self.conversation = conversation
        if let id = conversation.id {
            connection = ConversationConnection()
            rabbitProducer = RabbitPublisher(connection: connection!)
            rabbitListener = RabbitListener()
            rabbitListener?.listen(to: connection!)
        }
        if let name = conversation.name {
            routingKey = name.replacingOccurrences(of: ",", with: ".")
            if let session = SessionHandler.shared.user?.name {
                routingKey = routingKey?.appending(".\(session)")
            }
        }
        setupBindings()
    }
    
    deinit {
        connection?.channel.close()
    }
    func send(message: String) {
        guard let author = SessionHandler.shared.user?.name else { return }
        let rmsg = Message(content: message, author: author, conversation: conversation.id)
        guard let db = SessionHandler.shared.db,
              let routingKey = routingKey
                else { return }
        //adaugare in baza de date
        do {
            try rmsg.add(to: db)
        } catch (let error) {
            print("Failed to uplod message to firestore: \(error)")
        }
        rabbitProducer?.send(message: rmsg, on: routingKey)
    }
    
    func setupBindings() {
        rabbitListener?.$message.receive(on: DispatchQueue.main).sink { [weak self] message in
            
            guard let message = message, message.conversation == self?.conversation.id,
            ((self?.messages.contains(message)) == false) else { return }
            self?.messages.append(message)
            print("Added message to conversation")
        }.store(in: &subscribers)
    }
    
    @MainActor
    func loadMessages() async {
        guard let db = SessionHandler.shared.db else { return }
        do {
            messages = try await conversation.messages(from: db) ?? []
        } catch( let error) {
            print("Failed to fetch messages: \(error.localizedDescription)")
        }
    }
}
