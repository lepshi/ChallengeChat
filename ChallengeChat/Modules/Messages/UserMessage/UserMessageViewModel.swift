//
//  UserMessageViewModel.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 11.07.23.
//

import Foundation
import Combine

class UserMessageViewModel: ObservableObject {
    @Published var message: UserMessage?
    @Published var text: String?
    
    private var subscribers: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    private func bind() {
        $message.map { $0?.text }.assign(to: &$text)
    }
}
