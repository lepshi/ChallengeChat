//
//  AssistantMessageView.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 1.07.23.
//

import SwiftUI

struct AssistantMessageView: View {
    @StateObject var viewModel = AssistantMessageViewModel()
    var inputModel: AssistantMessage
    var body: some View {
        HStack {
            Spacer().frame(width: 16)
            Text(viewModel.text ?? "")
                .font(.system(size: 17, weight: .regular, design: .default))
                .foregroundColor(.black)
                .padding(16)
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(10, corners: [.topLeft])
                .cornerRadius(10, corners: [.bottomRight])
                .cornerRadius(10, corners: [.topRight])
            Spacer().frame(width: 16)
        }
        .onLoad {
            viewModel.message = inputModel
        }
    }
}

#if DEBUG

let assistantMessage = AssistantMessage(id: "",
                                        text: MessagesText.assistantLong.rawValue)

struct AssistantMessageView_Previews: PreviewProvider {
    static var previews: some View {
        AssistantMessageView(inputModel: assistantMessage)
            .previewLayout(.fixed(width: 300, height: 470))
    }
}

#endif
