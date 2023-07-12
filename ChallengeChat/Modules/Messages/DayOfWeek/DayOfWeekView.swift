//
//  DayOfWeekView.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 1.07.23.
//

import SwiftUI

struct DayOfWeekView: View {
    @StateObject var viewModel = DayOfWeekViewModel()
    var inputModel: DayOfWeek
    var body: some View {
        HStack {
            Spacer()
            Text(viewModel.text ?? "")
                .font(.system(size: 13, weight: .regular, design: .default))
                .foregroundColor(Color(red: 0.53, green: 0.54, blue: 0.6))
            Spacer()
        }
        .frame(height: 36)
        .onLoad {
            viewModel.message = inputModel
        }
    }
}

#if DEBUG

let dayOfWeek = DayOfWeek(id: "", text: MessagesText.dayOfWeek.rawValue)

struct DayOfWeekView_Previews: PreviewProvider {
    static var previews: some View {
        DayOfWeekView(inputModel: dayOfWeek)
            .previewLayout(.fixed(width: 300, height: 70))
    }
}

#endif
