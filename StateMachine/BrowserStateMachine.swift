//
//  BrowserStateMachine.swift
//  StateMachine
//
//  Created by Mathias Köhnke on 12/08/15.
//  Copyright (c) 2015 Mathias Köhnke. All rights reserved.
//

import Foundation
import TransitionKit

class BrowserStateMachine : StateMachine {
    
    let searchingStateName = "searchingState"
    let hasFoundPeersStateName = "hasFoundPeersState"
    let hasInvitedPeersStateName = "hasInvitedPeersState"
    let hasConnectedPeersStateName = "hasConnectedPeersSate"
    let sessionStartedStateName = "sessionStartedState"
    
    private let peerFoundEventName = "peerFoundEvent"
    private let peerInvitedEventName = "peerInvitedEvent"
    private let peerConnectedEventName = "peerConnectedEvent"
    private let lastFoundPeerLostEventName = "lastFoundPeerLostEvent"
    private let lastInvitedPeerLostEventName = "lastInvitedPeerLostEvent"
    private let lastConnectedPeerLostEventName = "lastConnectedPeerLostEvent"
    
    private let searchingState : TKState!
    private let hasFoundPeersState : TKState!
    private let hasInvitedPeersState : TKState!
    private let hasConnectedPeersState : TKState!
    private let sessionStartedState : TKState!
    
    private let peerFoundEvent : TKEvent!
    private let peerInvitedEvent : TKEvent!
    private let peerConnectedEvent : TKEvent!
    private let lastFoundPeerLostEvent : TKEvent!
    private let lastInvitedPeerLostEvent : TKEvent!
    private let lastConnectedPeerLostEvent : TKEvent!
    
    override init() {
        searchingState = TKState(name: searchingStateName)
        hasFoundPeersState = TKState(name: hasFoundPeersStateName)
        hasInvitedPeersState = TKState(name: hasInvitedPeersStateName)
        hasConnectedPeersState = TKState(name: hasConnectedPeersStateName)
        sessionStartedState = TKState(name: sessionStartedStateName)
        
        peerFoundEvent = TKEvent(name: peerFoundEventName, transitioningFromStates: [searchingState], toState: hasFoundPeersState)
        peerInvitedEvent = TKEvent(name: peerInvitedEventName, transitioningFromStates: [hasFoundPeersState], toState: hasInvitedPeersState)
        peerConnectedEvent = TKEvent(name: peerConnectedEventName, transitioningFromStates: [hasInvitedPeersState], toState: hasConnectedPeersState)
        
        lastFoundPeerLostEvent = TKEvent(name: lastFoundPeerLostEventName, transitioningFromStates: [hasFoundPeersState, hasInvitedPeersState, hasConnectedPeersState], toState: searchingState)
        lastInvitedPeerLostEvent = TKEvent(name: lastInvitedPeerLostEventName, transitioningFromStates: [hasInvitedPeersState, hasConnectedPeersState], toState: hasFoundPeersState)
        lastConnectedPeerLostEvent = TKEvent(name: lastConnectedPeerLostEventName, transitioningFromStates: [hasConnectedPeersState], toState: hasInvitedPeersState)
        
        super.init()
        
        lastFoundPeerLostEvent.setShouldFireEventBlock { [weak self] event, transition -> Bool in
            return self?.numberOfPeers(.Found) == 0 && self?.numberOfPeers(.Invited) == 0 && self?.numberOfPeers(.Connected) == 0
        }

        lastInvitedPeerLostEvent.setShouldFireEventBlock { [weak self] event, transition -> Bool in
            return self?.numberOfPeers(.Found) > 0 && self?.numberOfPeers(.Invited) == 0 && self?.numberOfPeers(.Connected) == 0
        }
        
        lastConnectedPeerLostEvent.setShouldFireEventBlock { [weak self] event, transition -> Bool in
            return self?.numberOfPeers(.Invited) > 0 && self?.numberOfPeers(.Connected) == 0
        }
    }
    
    override func activate() -> TKStateMachine {
        stateMachine.addStates([searchingState, hasFoundPeersState, hasInvitedPeersState, hasConnectedPeersState, sessionStartedState])
        stateMachine.addEvents([peerFoundEvent, peerInvitedEvent, peerConnectedEvent, lastFoundPeerLostEvent, lastInvitedPeerLostEvent, lastConnectedPeerLostEvent])
        stateMachine.initialState = searchingState
        stateMachine.activate()
        return super.activate()
    }
    
    override func setDidEnterStateBlock(stateName : String, block : DidEnterStateBlock) {
        super.setDidEnterStateBlock(stateName, block: block)
        
        let privateBlock = { (state: TKState!, transition: TKTransition!) -> (Void) in
            if transition != nil {
                block(source: transition.sourceState.name, destination: transition.destinationState.name)
            }
        }
        
        switch stateName {
            case searchingStateName: searchingState.setDidEnterStateBlock(privateBlock)
            case hasFoundPeersStateName: hasFoundPeersState.setDidEnterStateBlock(privateBlock)
            case hasInvitedPeersStateName: hasInvitedPeersState.setDidEnterStateBlock(privateBlock)
            case hasConnectedPeersStateName: hasConnectedPeersState.setDidEnterStateBlock(privateBlock)
            case sessionStartedStateName: sessionStartedState.setDidEnterStateBlock(privateBlock)
            default: NSLog("StateName didn't match.")
        }
    }
    
    func peerConnected(peer: Peer) -> Bool {
        peer.currentState = .Connected
        return fireEvent(peerConnectedEventName)
    }
    
    func peerInvited(peer: Peer) -> Bool {
        peer.currentState = .Invited
        return fireEvent(peerInvitedEventName)
    }
    
    func peerFound(peer: Peer) -> Bool {
        peer.currentState = .Found
        peers.addObject(peer)
        return fireEvent(peerFoundEventName)
    }
    
    func peerDisconnected(peer: Peer) -> Bool {
        peer.currentState = .Disconnected
        peers.removeObject(peer)
        
        for eventName in [lastConnectedPeerLostEventName, lastInvitedPeerLostEventName, lastFoundPeerLostEventName] {
            if (fireEvent(eventName)) { return true }
        }
        return false
    }
}