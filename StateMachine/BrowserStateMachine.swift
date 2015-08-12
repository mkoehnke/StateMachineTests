//
//  PeerStateMachine.swift
//  PeerInvitationStateTests
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
    
    override init() {
        super.init()
        let searchingState = TKState(name: searchingStateName)
        let hasFoundPeersState = TKState(name: hasFoundPeersStateName)
        let hasInvitedPeersState = TKState(name: hasInvitedPeersStateName)
        let hasConnectedPeersState = TKState(name: hasConnectedPeersStateName)
        let sessionStartedState = TKState(name: sessionStartedStateName)
        
        let peerFoundEvent = TKEvent(name: peerFoundEventName, transitioningFromStates: [searchingState], toState: hasFoundPeersState)
        let peerInvitedEvent = TKEvent(name: peerInvitedEventName, transitioningFromStates: [hasFoundPeersState], toState: hasInvitedPeersState)
        let peerConnectedEvent = TKEvent(name: peerConnectedEventName, transitioningFromStates: [hasInvitedPeersState], toState: hasConnectedPeersState)
        
        let lastFoundPeerLostEvent = TKEvent(name: lastFoundPeerLostEventName, transitioningFromStates: [hasFoundPeersState, hasInvitedPeersState, hasConnectedPeersState], toState: searchingState)
        lastFoundPeerLostEvent.setShouldFireEventBlock { [weak self] event, transition -> Bool in
            return self?.numberOfPeers(.Found) == 0 && self?.numberOfPeers(.Invited) == 0 && self?.numberOfPeers(.Connected) == 0
        }
        let lastInvitedPeerLostEvent = TKEvent(name: lastInvitedPeerLostEventName, transitioningFromStates: [hasInvitedPeersState, hasConnectedPeersState], toState: hasFoundPeersState)
        lastInvitedPeerLostEvent.setShouldFireEventBlock { [weak self] event, transition -> Bool in
            return self?.numberOfPeers(.Found) > 0 && self?.numberOfPeers(.Invited) == 0 && self?.numberOfPeers(.Connected) == 0
        }
        let lastConnectedPeerLostEvent = TKEvent(name: lastConnectedPeerLostEventName, transitioningFromStates: [hasConnectedPeersState], toState: hasInvitedPeersState)
        lastConnectedPeerLostEvent.setShouldFireEventBlock { [weak self] event, transition -> Bool in
            return self?.numberOfPeers(.Invited) > 0 && self?.numberOfPeers(.Connected) == 0
        }
        
        stateMachine.addStates([searchingState, hasFoundPeersState, hasInvitedPeersState, hasConnectedPeersState, sessionStartedState])
        stateMachine.addEvents([peerFoundEvent, peerInvitedEvent, peerConnectedEvent, lastFoundPeerLostEvent, lastInvitedPeerLostEvent, lastConnectedPeerLostEvent])
        stateMachine.initialState = searchingState
        stateMachine.activate()
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