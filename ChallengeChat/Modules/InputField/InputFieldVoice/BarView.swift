//
//  BarView.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 2.07.23.
//

import SwiftUI

struct BarView: View {
    var value: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.9, green: 0.91, blue: 0.92))
                .frame(width: (UIScreen.main.bounds.width - CGFloat(VoiceService.numberOfSamples) * 4) / CGFloat(VoiceService.numberOfSamples), height: value)
        }
    }
}

#if DEBUG

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 100)
    }
}

#endif
