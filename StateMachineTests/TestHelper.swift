//
//  TestHelper.swift
//  StateMachine
//
//  Created by Mathias Köhnke on 13/08/15.
//  Copyright (c) 2015 Mathias Köhnke. All rights reserved.
//

import Foundation

struct TestHelper {
    
    static func printState(stateMachine: StateMachine) {
        NSLog("Current state: %@", stateMachine.currentState)
        NSLog("Peers: Found(%d), Invited(%d), Connected(%d), Selected(%d), Accepted(%d)",
            stateMachine.numberOfPeers(.Found), stateMachine.numberOfPeers(.Invited), stateMachine.numberOfPeers(.Connected),
            stateMachine.numberOfPeers(.Selected), stateMachine.numberOfPeers(.Accepted))
    }
    
}