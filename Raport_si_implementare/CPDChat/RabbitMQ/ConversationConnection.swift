//
//  ConversationConnection.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/20/23.
//

import Foundation
import RMQClient

protocol Connection {
    var exchange: RMQExchange { get set }
    var channel: RMQChannel { get set }
    var queue: RMQQueue { get set }
}

struct ConversationConnection: Connection {
    var exchange: RMQExchange
    
    var channel: RMQChannel
    
    var queue: RMQQueue
    
    init() {
        channel = RabbitService.shared.connection.createChannel()
        exchange = channel.topic("conv")
        let user = SessionHandler.shared.user!.name!
        queue = channel.queue("\(user).conv")
        queue.bind(exchange, routingKey: "#.\(user).#")
    }
}
