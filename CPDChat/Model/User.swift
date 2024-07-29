//
//  User.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/18/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var name: String?
}

extension User: Identifiable {
    
    var id: String {
        name ?? ""
    }
    
    func getConversations(from db: Database) async throws -> [Conversation]? {
        guard let _ = name else { return nil }
        return try await db.getRecords(from: "\(collectionName)/convs")
    }
    
    static func users(from db: Database) async throws -> [User]? {
        return try await db.getRecords(from: "users")
    }
    var collectionName: String {
        guard let name = name else { return "" }
        return "users/\(name)"
    }
    
}

