//
//  GlobalFunctions.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 12.07.23.
//

import Foundation

func delay(_ delay: Double, closure:@escaping () -> Void) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
