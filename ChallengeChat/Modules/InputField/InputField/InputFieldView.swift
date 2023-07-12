//
//  UserInputFieldView.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 2.07.23.
//

import SwiftUI
import Combine

struct InputFieldView: View, KeyboardReadable {
    @EnvironmentObject var messageRepository: MessageRepository
    @ObservedObject var viewModel = InputFieldViewModel()
    @ObservedObject var voiceService: VoiceService
    @State var isShowingVoice = false
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            inputTextBarView
            if isShowingVoice {
                VoiceView(voiceService: voiceService)
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity).animation(.easeInOut(duration: 0.4)))
            }
        }
    }
    
    var inputTextBarView: some View {
        ZStack {
            if !isShowingVoice {
                Rectangle()
                    .foregroundColor(Color(red: 0.95, green: 0.96, blue: 0.96))
                    .frame(height: 40)
                    .background(Color(red: 0.95, green: 0.96, blue: 0.96))
                    .cornerRadius(100)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: viewModel.rightPadding))
                    .animation(.easeIn(duration: 0.2), value: viewModel.rightPadding)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    if viewModel.text.count == 0 {
                        Image("star")
                    }
                    mainTextField
                    sendButton
                    if viewModel.text.count == 0 {
                        Spacer()
                            .frame(width: 16)
                    }
                }
            }
            else {
                HStack {
                    Spacer()
                    sendVoiceButton
                }
                .frame(height: 40)
            }
        }
        .padding(EdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16))
        .background(.white)
    }
    
    var inputVoiceBarView: some View {
        HStack {
            Spacer()
            sendVoiceButton
        }
        .frame(height: 58)
        .background(.white)
    }
    
    var mainTextField: some View {
        TextField(MessagesText.inputFieldPlaceholder.rawValue, text: $viewModel.text)
            .focused($isInputFocused)
            .keyboardType(.alphabet)
            .textContentType(.oneTimeCode)
            .autocorrectionDisabled(true)
            .onReceive(keyboardPublisher) { isKeyboardVisible in
                if isKeyboardVisible {
                    withAnimation(Animation.easeOut(duration: 0.05)) {
                        isShowingVoice = !isKeyboardVisible
                    }
                }
            }
    }
    
    var sendButton: some View {
        Button {
            if viewModel.text.count == 0 {
                withAnimation {
                    if !isShowingVoice {
                        isInputFocused = false
                        isShowingVoice = true
                    }
                    voiceService.setupSpeech()
                    voiceService.togleSpeechToText()
                }
            }
            else {
                messageRepository.add(text: viewModel.text)
                viewModel.text = ""
            }
        } label: {
            if self.viewModel.text.count == 0, !isShowingVoice {
                Image("mic")
            }
            else {
                sendView
            }
        }
    }
        
    var sendVoiceButton: some View {
        Button {
            let isSpeech = voiceService.voiceText.count > 0 && voiceService.voiceText != MessagesText.speechRecognizerVoicePlaceholder.rawValue
            if isSpeech {
                voiceService.stopRecording()
                if voiceService.voiceText.count > 0 {
                    messageRepository.add(text: voiceService.voiceText)
                    voiceService.clearVoiceText()
                }
                isShowingVoice = false
            }
            else {
                voiceService.stopRecording()
                isShowingVoice = false
            }
        } label: {
            let isSpeech = voiceService.voiceText.count > 0 && voiceService.voiceText != MessagesText.speechRecognizerVoicePlaceholder.rawValue
            if isSpeech {
                Image("sendVoice").frame(width: 48, height: 48)
            }
            else {
                Image("stop").frame(width: 48, height: 48)
            }
        }
        .transition(AnyTransition.scale.animation(.easeInOut(duration: 4)))
    }
    
    var sendView: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 40, height: 40)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.25, green: 0.67, blue: 0.94), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.28, green: 0.6, blue: 0.98), location: 0.50),
                            Gradient.Stop(color: Color(red: 0.57, green: 0.43, blue: 0.91), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.43, y: -0.53),
                        endPoint: UnitPoint(x: 0.78, y: 1.44)
                    )
                )
                .cornerRadius(100)
            Image("up").frame(width: 40, height: 40)
        }
    }
}

#if DEBUG

let inputFieldViewModel: InputFieldViewModel = {
    let val = InputFieldViewModel()
    val.text = MessagesText.textMessage.rawValue
    return val
}()

struct UserInputFieldView_Previews_Placeholder: PreviewProvider {
    static var previews: some View {
        InputFieldView(voiceService: VoiceService())
            .environmentObject(MessageRepository())
            .frame(width: 300, height: 200)
            
    }
}

struct UserInputFieldView_Previews_Text: PreviewProvider {
    static var previews: some View {
        InputFieldView(viewModel: inputFieldViewModel, voiceService: VoiceService())
            .environmentObject(MessageRepository())
            .frame(width: 300, height: 200)
    }
}

struct UserInputFieldView_Previews_Voice: PreviewProvider {
    static var previews: some View {
        InputFieldView(voiceService: VoiceService(), isShowingVoice: true)
            .environmentObject(MessageRepository())
            .frame(width: 300, height: 200)
    }
}

#endif

