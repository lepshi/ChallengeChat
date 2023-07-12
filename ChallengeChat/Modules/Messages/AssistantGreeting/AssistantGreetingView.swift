//
//  AssistantGreetingView.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 1.07.23.
//

import SwiftUI

struct AssistantGreetingView: View {
    @StateObject var viewModel = AssistantGreetingViewModel()
    var inputModel: AssistantGreeting
    
    var body: some View {
        HStack(alignment: .top, spacing: 9) {
            Spacer()
                .frame(width: 16)
            Image(viewModel.imageName ?? "")
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title ?? "")
                        .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.12))
                Text(viewModel.subTitle ?? "")
                    .font(.system(size: 20, weight: .regular, design: .default))
                
                    .foregroundColor(Color(red: 0.53, green: 0.54, blue: 0.6))
            }
            Spacer()
            Spacer().frame(width: 16)
        }
        .onLoad {
            viewModel.message = inputModel
        }
    }
}

#if DEBUG

let assistantGreeting = AssistantGreeting(id: "", imageName: "assistantAvatar", title: "Good morning, Samantha", subTitle: "How can I help you today?")

struct AssistantGreetingView_Previews: PreviewProvider {
    static var previews: some View {
        AssistantGreetingView(inputModel: assistantGreeting)
    }
}

#endif
