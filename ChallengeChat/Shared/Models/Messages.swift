//
//  Messages.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 1.07.23.
//

import Foundation
import SwiftUI

enum Message {
    case assistantGreeting(model: AssistantGreeting)
    case assistant(model: AssistantMessage)
    case user(model: UserMessage)
    case dayOfWeek(model: DayOfWeek)
}

extension Message {
    var id: String {
        switch self {
        case let .assistant(model: assistant):
            return assistant.id
        case let .user(model: user):
            return user.id
        case let .dayOfWeek(model: dayOfWeek):
            return dayOfWeek.id
        case .assistantGreeting(model: let model):
            return model.id
        }
    }
    
    var view: any View {
        switch self {
        case .assistant(model: let assistant):
            return AssistantMessageView(inputModel: assistant)
        case .user(model: let user):
            return UserMessageView(inputModel: user)
        case .dayOfWeek(model: let dayOfWeek):
            return DayOfWeekView(inputModel: dayOfWeek)
        case .assistantGreeting(model: let model):
            return AssistantGreetingView(inputModel: model)
        }
    }
}

extension Message: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}

struct TestMessageData {
    var messages: [Message] = {
        let assistantGreeting = AssistantGreeting(id: String.random(), imageName: "assistantAvatar", title: "Good morning, Samantha", subTitle: "How can I help you today?")
        let assistantMessage = AssistantMessage(id: String.random(), text: MessagesText.assistantLong.rawValue)
        let userMessage = UserMessage(id: String.random(), text: MessagesText.userLong.rawValue)
        let dayOfWeek = DayOfWeek(id: String.random(), text: MessagesText.dayOfWeek.rawValue)
        return [
            Message.assistantGreeting(model: assistantGreeting),
            Message.dayOfWeek(model: dayOfWeek),
            Message.user(model: userMessage),
            Message.assistant(model: assistantMessage),
        ]
    }()
}
