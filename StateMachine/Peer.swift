//
//  Peer.swift
//  StateMachine
//
//  Created by Mathias Köhnke on 31/07/15.
//  Copyright (c) 2015 Mathias Köhnke. All rights reserved.
//

import Foundation

class Peer : NSObject {
    
    enum State {
        case Found
        case Invited
        case Connected
        case Disconnected
        case Selected
        case Accepted
    }
    
    var name : String!
    var currentState : State = .Disconnected
    
    init(name : String, currentState : State = .Disconnected) {
        super.init()
        self.name = name
        self.currentState = currentState
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? Peer {
            return self.name == object.name
        }
        return false
    }
}