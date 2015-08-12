//
//  AdvertiserStateMachine.swift
//  StateMachine
//
//  Created by Mathias Köhnke on 12/08/15.
//  Copyright (c) 2015 Mathias Köhnke. All rights reserved.
//

import Foundation

class AdvertiserStateMachine : StateMachine {

    private let searchingStateName = "searchingState"
    private let hasReceivedInvitationsStateName = "hasFoundPeersState"
    private let hasStateName = "hasInvitedPeersState"
    private let hasConnectedPeersStateName = "hasConnectedPeersSate"
    private let sessionStartedStateName = "sessionStartedState"
    
    private let peerFoundEventName = "peerFoundEvent"
    private let peerInvitedEventName = "peerInvitedEvent"
    private let peerConnectedEventName = "peerConnectedEvent"
    private let lastFoundPeerLostEventName = "lastFoundPeerLostEvent"
    private let lastInvitedPeerLostEventName = "lastInvitedPeerLostEvent"
    private let lastConnectedPeerLostEventName = "lastConnectedPeerLostEvent"
    
}