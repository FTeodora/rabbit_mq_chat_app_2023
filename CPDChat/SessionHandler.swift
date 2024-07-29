//
//  SessionHandler.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/20/23.
//

import Foundation
import Combine
import FirebaseFirestore

class SessionHandler {
    static let shared = SessionHandler()
    var user: User?
    var db: Database?
    
    private var subscriptions = Set<AnyCancellable>()
    
    func startSession(with username: String) {
        user = User(name: username.lowercased())
    }
}
