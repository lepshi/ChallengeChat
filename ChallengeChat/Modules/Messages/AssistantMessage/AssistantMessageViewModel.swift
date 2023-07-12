//
//  AssistantMessageViewModel.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 11.07.23.
//

import Foundation
import Combine

class AssistantMessageViewModel: ObservableObject {
    @Published var message: AssistantMessage?
    @Published var text: String?
    
    private var subscribers: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    private func bind() {
        $message.map { $0?.text }.assign(to: &$text)
    }
}
