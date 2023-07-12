//
//  UserMessage.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 1.07.23.
//

import Foundation

struct UserMessage: Codable, Identifiable {
    let id: String
    let text: String
}
