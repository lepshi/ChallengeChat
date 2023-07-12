//
//  ConversationView.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 2.07.23.
//

import SwiftUI

struct ConversationView: View {
    @StateObject var messageRepository = MessageRepository()
    @StateObject var voiceService = VoiceService()
    
    var body: some View {
        VStack(spacing: 0) {
            MessageListView()
            InputFieldView(voiceService: voiceService)
                .background(Color.white
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: -8))
                
        }
        .environmentObject(messageRepository)
    }
}

#if DEBUG

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}

#endif
