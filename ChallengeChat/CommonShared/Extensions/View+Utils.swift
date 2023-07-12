//
//  View+Utils.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 11.07.23.
//

import SwiftUI

// MARK: - ViewDidLoadModifier
struct ViewDidLoadModifier: ViewModifier {
    @State private var isViewDidLoad = false
    private let action: (() -> Void)

    init(perform action: @escaping (() -> Void)) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if isViewDidLoad == false {
                isViewDidLoad = true
                action()
            }
        }
    }
}

extension View {
    func onLoad(perform action: @escaping (() -> Void)) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}
