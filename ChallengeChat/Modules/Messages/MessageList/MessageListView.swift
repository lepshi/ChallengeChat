//
//  MessageListView.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 1.07.23.
//

import SwiftUI

struct MessageListView: View {
    @EnvironmentObject var messageRepository: MessageRepository
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical) {
                LazyVStack {
                    messagesView
                }
                .onAppear {
                    scrollView.scrollTo(messageRepository.messages[messageRepository.messages.endIndex - 1])
                }
            }
            .onChange(of: messageRepository.messages.count) { _ in
                if let last = messageRepository.messages.last {
                    withAnimation {
                        scrollView.scrollTo(last.id)
                    }
                }
            }
        }
    }
    
    var messagesView: some View {
        ForEach(messageRepository.messages, id: \.id) { mes in
            switch mes {
            case .assistantGreeting(model: let model):
                AssistantGreetingView(inputModel: model)
            case .assistant(model: let assistant):
                AssistantMessageView(inputModel: assistant)
            case .user(model: let user):
                UserMessageView(inputModel: user)
            case .dayOfWeek(model: let dayOfWeek):
                DayOfWeekView(inputModel: dayOfWeek)
            }
        }
    }
}

#if DEBUG

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView().environmentObject(MessageRepository())
    }
}

#endif
