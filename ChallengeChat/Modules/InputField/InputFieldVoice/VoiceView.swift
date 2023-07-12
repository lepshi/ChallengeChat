//
//  VoiceView.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 4.07.23.
//

import SwiftUI

struct VoiceView: View {
    @ObservedObject var voiceService: VoiceService
    var body: some View {
        VStack {
            Text(voiceService.voiceText)
            Spacer().frame(height: 20)
            chart
        }
        .frame(height: 200)
    }
    
    var chart: some View {
        HStack(spacing: 4) {
            ForEach(voiceService.soundSamples, id: \.self) { level in
                BarView(value: level)
            }
        }
        .frame(height: 39)
    }
}

#if DEBUG

struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView(voiceService: VoiceService())
    }
}

#endif
