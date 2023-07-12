//
//  UserMessageView.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 1.07.23.
//

import SwiftUI

struct UserMessageView: View {
    @StateObject var viewModel = UserMessageViewModel()
    var inputModel: UserMessage
    
    var body: some View {
        HStack {
            Spacer().frame(width: 16)
            Spacer()
            Text(viewModel.text ?? "")
                .font(.system(size: 17, weight: .regular, design: .default))
                .foregroundColor(.white)
                .padding(16)
                .background(Color(red: 0.31, green: 0.57, blue: 0.97))
                .cornerRadius(10, corners: [.topLeft])
                .cornerRadius(10, corners: [.bottomLeft])
                .cornerRadius(10, corners: [.topRight])
                
            Spacer().frame(width: 16)
        }
        .onLoad {
            viewModel.message = inputModel
        }
    }
}

#if DEBUG

let userMessage = UserMessage(id: "", text: MessagesText.userLong.rawValue)

struct UserMessageView_Previews: PreviewProvider {
    static var previews: some View {
        UserMessageView(inputModel: userMessage)
            .previewLayout(.fixed(width: 300, height: 170))
    }
}

#endif
