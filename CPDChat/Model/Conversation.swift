//
//  Conversation.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/18/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

enum ConversationType: Codable {
    case person, group, broadcast
    
    var icon: Image {
        switch self {
        case .person:
            return Image(systemName: "person.fill")
        case .group:
            return Image(systemName: "person.3.fill")
        case .broadcast:
            return Image(systemName: "megaphone.fill")
        }
    }
}

struct Conversation: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String?
    var type: ConversationType = .person
}

extension Conversation {
    
    func add(to db: Database, with participants: [String], and message: Message) throws {
        try db.add(in: "conversation", item: self)
        try message.add(to: db)
        try participants.forEach { username in
            try db.add(in: "users/\(username)/convs", item: Conversation(id: id, name: participants.filter { $0 != username}.joined(separator: ","), type: type))
        }
    }
    
    func messages(from db: Database) async throws -> [Message]? {
        guard let id = id else { return nil }
        return try await db.getRecords(from: "conversation/\(id)/mesg")?.sorted()
    }
    
    static func listen(to db: Database, for user: String, callback: @escaping (QuerySnapshot?, Error?) -> Void) {
        db.snapshotListener(for: "users/\(user)/convs", listener: callback)
    }
}
