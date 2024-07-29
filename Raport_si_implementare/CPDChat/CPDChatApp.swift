//
//  CPDChatApp.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/18/23.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseFirestore

var lightGray = Color(uiColor: UIColor(named:"lightGray")!)
@main
struct CPDChatApp: App {
    init() {
        FirebaseApp.configure()
        SessionHandler.shared.db = Database(db: Firestore.firestore())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


