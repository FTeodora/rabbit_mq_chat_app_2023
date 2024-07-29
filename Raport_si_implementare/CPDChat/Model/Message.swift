//
//  Message.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/18/23.
//

import Foundation
import RMQClient
import FirebaseFirestoreSwift

struct Message: Codable, Identifiable, Comparable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var content: String
    var author: String
    var date: Date = Date()
    var conversation: String?
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        lhs.date < rhs.date
    }
    
    enum CodingKeys: CodingKey {
        case id
        case content
        case author
        case date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct MessageJSON: Codable {
    var id: String?
    var content: String
    var author: String
    var date: Date
    var conversation: String?
}

extension Message: RabbitCodable {
    func rabbitMessage(with encoder: JSONEncoder) -> Data? {
        try? encoder.encode(MessageJSON(id: id, content: content, author: author, date: date, conversation: conversation))
    }
    
    static func decodeMessage(data: Data, with decoder: JSONDecoder) -> Message? {
        guard let decoded = try? decoder.decode(MessageJSON.self, from: data) else { return nil }
        return Message(id: decoded.id, content: decoded.content, author: decoded.author, date: decoded.date, conversation: decoded.conversation)
    }
    
    func add(to db: Database) throws {
        guard let id = conversation else { return }
        try db.add(in: "conversation/\(id)/mesg", item: self)
    }
}

protocol RabbitCodable: Codable {
    func rabbitMessage(with encoder: JSONEncoder) -> Data?
    static func decodeMessage(data: Data, with decoder: JSONDecoder) -> Self?
}
