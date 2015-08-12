//
//  StateMachine.swift
//  PeerInvitationStateTests
//
//  Created by Mathias Köhnke on 12/08/15.
//  Copyright (c) 2015 Mathias Köhnke. All rights reserved.
//

import Foundation
import TransitionKit

class StateMachine : NSObject {
    
    internal(set) var peers = NSMutableOrderedSet()
    internal let stateMachine = TKStateMachine()
    
    var currentState : String {
        get { return stateMachine.currentState.name }
    }
    
    // MARK: Helper Methods
    
    internal func fireEvent(eventName: String) -> Bool {
        return stateMachine.canFireEvent(eventName) && stateMachine.fireEvent(eventName, userInfo: nil, error: nil)
    }
    
    func numberOfPeers(state: Peer.State) -> Int {
        return peers.array.filter { ($0 as! Peer).currentState == state }.count
    }
}