//
//  RabbitService.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/19/23.
//

import Foundation
import RMQClient

class RabbitService {
    static var shared = RabbitService()
    let connection = RMQConnection(uri: "amqps://hmejcqoa:ByNiIG-z6iiY7EQxE7A_lcQfv31HPCTL@shark.rmq.cloudamqp.com/hmejcqoa",
                             delegate: RMQConnectionDelegateLogger())

    
    private init() {
        
    }
    
    func connect(onSuccess: @escaping ()->Void = {}) {
        connection.start {
            print("Connected")
            onSuccess()
        }
    }
}

