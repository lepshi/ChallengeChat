//
//  MessageListViewModel.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 11.07.23.
//

import Foundation
import Combine

class MessageListViewModel: ObservableObject {
    @Published var messages: [Message] = {
        TestMessageData().messages
    }()
        
    func add(text: String) {
        let message = UserMessage(id: String.random(), text: text)
        let userMessage = Message.user(model: message)
        add(message: userMessage)
    }
    
    private func add(message: Message) {
        messages.append(message)
        delay(1) {
            self.addAssistantMessage()
        }
    }
    
    private func addAssistantMessage() {
        let message = AssistantMessage(id: String.random(), text: MessagesText.assistantLong.rawValue)
        let userMessage = Message.assistant(model: message)
        messages.append(userMessage)
    }
}
