//
//  AssistantGreetingViewModel.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 11.07.23.
//

import Foundation
import Combine

class AssistantGreetingViewModel: ObservableObject {
    @Published var message: AssistantGreeting?
    
    @Published var imageName: String?
    @Published var title: String?
    @Published var subTitle: String?
    
    private var subscribers: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    private func bind() {
        $message.map { $0?.imageName }.assign(to: &$imageName)
        $message.map { $0?.title }.assign(to: &$title)
        $message.map { $0?.subTitle }.assign(to: &$subTitle)
    }
}
