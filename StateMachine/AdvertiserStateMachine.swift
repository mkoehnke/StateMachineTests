//
//  AdvertiserStateMachine.swift
//  StateMachine
//
//  Created by Mathias Köhnke on 12/08/15.
//  Copyright (c) 2015 Mathias Köhnke. All rights reserved.
//

import Foundation
import TransitionKit

class AdvertiserStateMachine : StateMachine {

    let searchingStateName = "searchingState"
    let hasReceivedInvitationsStateName = "hasReceivedInvitationsState"
    let hasSelectedInvitationStateName = "hasSelectedInvitationState"
    let hasAcceptedInvitationStateName = "hasAcceptedInvitationState"
    let connectedStateName = "connectedState"
    
    private let invitationFoundEventName = "invitationFoundEvent"
    private let invitationSelectedEventName = "invitationSelectedEvent"
    private let invitationAcceptedEventName = "invitationAcceptedEvent"
    private let hasConnectedEventName = "hasConnectedEventName"
    private let connectionLostEventName = "connectionLostEvent"
 
    
    override init() {
        super.init()
        let searchingState = TKState(name: searchingStateName)
        let hasReceivedInvitationsState = TKState(name: hasReceivedInvitationsStateName)
        let hasSelectedInvitationState = TKState(name: hasSelectedInvitationStateName)
        let hasAcceptedInvitationState = TKState(name: hasAcceptedInvitationStateName)
        let connectedState = TKState(name: connectedStateName)
        
        let invitationFoundEvent = TKEvent(name: invitationFoundEventName, transitioningFromStates: [searchingState], toState: hasReceivedInvitationsState)
        let invitationSelectedEvent = TKEvent(name: invitationSelectedEventName, transitioningFromStates: [hasReceivedInvitationsState], toState: hasSelectedInvitationState)
        let invitationAcceptedEvent = TKEvent(name: invitationAcceptedEventName, transitioningFromStates: [hasSelectedInvitationState], toState: hasAcceptedInvitationState)
        let hasConnectedEvent = TKEvent(name: hasConnectedEventName, transitioningFromStates: [hasAcceptedInvitationState], toState: connectedState)
        let connectionLostEvent = TKEvent(name: connectionLostEventName, transitioningFromStates: [connectedState, hasAcceptedInvitationState, hasSelectedInvitationState, hasReceivedInvitationsState], toState: searchingState)
        
        stateMachine.addStates([searchingState, hasReceivedInvitationsState, hasSelectedInvitationState, hasAcceptedInvitationState, connectedState])
        stateMachine.addEvents([invitationFoundEvent, invitationSelectedEvent, invitationAcceptedEvent, hasConnectedEvent, connectionLostEvent])
        stateMachine.initialState = searchingState
        stateMachine.activate()
    }
    
    func invitationFound(peer: Peer) -> Bool {
        peer.currentState = .Found
        peers.addObject(peer)
        return fireEvent(invitationFoundEventName)
    }
    
    func invitationSelected(peer: Peer) -> Bool {
        peer.currentState = .Selected
        return fireEvent(invitationSelectedEventName)
    }
    
    func invitationAccepted(peer: Peer) -> Bool {
        peer.currentState = .Accepted
        return fireEvent(invitationAcceptedEventName)
    }
    
    func hasConnected(peer: Peer) -> Bool {
        peer.currentState = .Connected
        return fireEvent(hasConnectedEventName)
    }
    
    func connectionLostEvent(peer: Peer) -> Bool {
        peer.currentState = .Disconnected
        peers.removeObject(peer)
        return fireEvent(connectionLostEventName)
    }

}