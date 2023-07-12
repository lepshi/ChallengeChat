//
//  AssistantGreeting.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 1.07.23.
//

import Foundation

struct AssistantGreeting: Codable, Identifiable {
    let id: String
    let imageName: String
    let title: String
    let subTitle: String
}
