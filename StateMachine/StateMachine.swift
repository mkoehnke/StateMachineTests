//
//  StateMachine.swift
//  StateMachine
//
//  Created by Mathias Köhnke on 12/08/15.
//  Copyright (c) 2015 Mathias Köhnke. All rights reserved.
//

import Foundation
import TransitionKit

typealias DidEnterStateBlock = (source: String, destination: String) -> (Void)

class StateMachine : NSObject {
    
    internal(set) var peers = NSMutableOrderedSet()
    internal let stateMachine = TKStateMachine()
    
    var currentState : String {
        get { return stateMachine.currentState.name }
    }
    
    func activate() -> TKStateMachine {
        // Override
        return stateMachine
    }
    
    func setDidEnterStateBlock(stateName : String, block : DidEnterStateBlock) {
        if stateMachine.isActive() {
            NSException(name:NSInvalidArgumentException, reason:"StateMachine must not be active.", userInfo:nil).raise()
        }
    }
    
    // MARK: Helper Methods
    
    internal func fireEvent(eventName: String) -> Bool {
        if stateMachine.canFireEvent(eventName) {
            do {
                try stateMachine.fireEvent(eventName, userInfo: nil)
            } catch {
                return false
            }
        }
        return false
    }
    
    func numberOfPeers(state: Peer.State) -> Int {
        return peers.array.filter { ($0 as! Peer).currentState == state }.count
    }
}