//
//  Database.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/22/23.
//

import Foundation
import FirebaseFirestore

class Database: ObservableObject {
    var db: Firestore
    init(db: Firestore) {
        self.db = db
    }
    
    func getRecord<T: Decodable>(from collection: String, with id: String) async throws -> T? {
        try await db.collection(collection).document(id).getDocument(as: T.self, decoder: Firestore.Decoder())
    }
    
    func getRecords<T: Decodable>(from collection: String) async throws -> [T]? {
        try await db.collection(collection).getDocuments().documents.compactMap { document in
            try? document.data(as: T.self, decoder: Firestore.Decoder())
        }
    }
    
    func getRecords<T: Decodable>(from collection: String, with field: String, equalTo value: Any) async throws -> [T]? {
        try await db.collection(collection).whereField(field, isEqualTo: value).getDocuments().documents.compactMap { document in
            try? document.data(as: T.self, decoder: Firestore.Decoder()) }
    }
    
    func add<T: Encodable&Identifiable>(in collection: String, item: T) throws {
        try db.collection(collection).document(item.id as! String).setData(Firestore.Encoder().encode(item))
    }
    
    func snapshotListener(for collection: String, listener: @escaping (QuerySnapshot?, Error?) -> Void) {
        db.collection(collection).addSnapshotListener(listener)
    }
}
