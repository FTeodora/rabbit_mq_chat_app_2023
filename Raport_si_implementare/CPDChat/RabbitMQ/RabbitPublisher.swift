//
//  RabbitPublisher.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/20/23.
//

import Foundation
import RMQClient

class RabbitPublisher<T:RabbitCodable> {
    let encoder = JSONEncoder()
    let connection: Connection
    
    init(connection: Connection) {
        self.connection = connection
    }
    
    deinit {
        connection.channel.close()
    }

    func send(message: T, on routingKey: String) {
        
        guard let data = message.rabbitMessage(with: encoder) else { return }
        connection.exchange.publish(data, routingKey: routingKey)
    }
}
