//
//  InputFieldViewModel.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 12.07.23.
//

import Foundation
import Combine

class InputFieldViewModel: ObservableObject {
    @Published var text: String = ""
    var rightPadding: CGFloat = 0
    private var subscribers: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    private func bind() {
        $text.sink { [weak self] val in
            self?.rightPadding = val.count > 0 ? 50 : 0
        }
        .store(in: &subscribers)
    }
}
