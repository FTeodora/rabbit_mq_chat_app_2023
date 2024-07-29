//
//  ItemSelectionViewModel.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/22/23.
//

import Foundation
import Combine


class SelectableItem: ObservableObject, Identifiable {
    @Published var isSelected = false
    var name: String
    var hiddenField: String?
    var id: String {
        return name
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, hiddenField: String) {
        self.name = name
        self.hiddenField = hiddenField
    }
}

class ItemSelectionViewModel: ObservableObject {
    var type: ConversationType
    @Published var items: [SelectableItem] = []
    var selectedItems: [SelectableItem] {
        items.filter { $0.isSelected }
    }
    
    init(type: ConversationType) {
        self.type = type
    }
    
    @MainActor
    func fetchUsers() async {
        guard let db = SessionHandler.shared.db, let session = SessionHandler.shared.user?.name else { return }
        do {
            let users: [SelectableItem]? = try await User.users(from: db)?.compactMap { user in
                guard let username = user.name, username != session else { return nil }
                return SelectableItem(name: username)
            }
            guard let users = users else { return }
            self.items = users
        } catch (let error) {
            print("Failed to fetch users: \(error)")
        }
    }
    
    @MainActor
    func fetchConversations() async {
        do {
            if let db = SessionHandler.shared.db, let user = SessionHandler.shared.user {
                let conversations = await (try user.getConversations(from: db) ?? [])
                items = conversations.compactMap { conversation in
                    guard let name = conversation.name, let id = conversation.id else { return nil }
                    return SelectableItem(name: name, hiddenField: id)
                }
            }
        } catch(let error) {
            print("Failed to load conversations: \(error.localizedDescription)")
        }
    }

}
