//
//  RabbitListener.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 5/20/23.
//

import Foundation
import RMQClient

class RabbitListener<T: RabbitCodable> {
    let decoder = JSONDecoder()
    let connection = RabbitService.shared.connection
    @Published var message: T?
    
    func listen(to connection: Connection) {
        if self.connection.isOpen() {
            connection.queue.subscribe { [weak self] message in
                guard let self = self,
                      let body = message.body,
                      let message = T.decodeMessage(data: body, with: self.decoder)
                else { return }
                print("Received: \(message)")
                self.message = message
            }
        } else {
            print("Connection isn't open")
        }
    }
}
