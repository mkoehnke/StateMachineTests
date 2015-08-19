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
 
    private let searchingState : TKState!
    private let hasReceivedInvitationsState : TKState!
    private let hasSelectedInvitationState : TKState!
    private let hasAcceptedInvitationState : TKState!
    private let connectedState : TKState!
    
    private let invitationFoundEvent : TKEvent!
    private let invitationSelectedEvent : TKEvent!
    private let invitationAcceptedEvent : TKEvent!
    private let hasConnectedEvent : TKEvent!
    private let connectionLostEvent : TKEvent!
    
    override init() {
        searchingState = TKState(name: searchingStateName)
        hasReceivedInvitationsState = TKState(name: hasReceivedInvitationsStateName)
        hasSelectedInvitationState = TKState(name: hasSelectedInvitationStateName)
        hasAcceptedInvitationState = TKState(name: hasAcceptedInvitationStateName)
        connectedState = TKState(name: connectedStateName)
        
        invitationFoundEvent = TKEvent(name: invitationFoundEventName, transitioningFromStates: [searchingState], toState: hasReceivedInvitationsState)
        invitationSelectedEvent = TKEvent(name: invitationSelectedEventName, transitioningFromStates: [hasReceivedInvitationsState], toState: hasSelectedInvitationState)
        invitationAcceptedEvent = TKEvent(name: invitationAcceptedEventName, transitioningFromStates: [hasSelectedInvitationState], toState: hasAcceptedInvitationState)
        hasConnectedEvent = TKEvent(name: hasConnectedEventName, transitioningFromStates: [hasAcceptedInvitationState], toState: connectedState)
        connectionLostEvent = TKEvent(name: connectionLostEventName, transitioningFromStates: [connectedState, hasAcceptedInvitationState, hasSelectedInvitationState, hasReceivedInvitationsState], toState: searchingState)
        super.init()
    }
    
    override func activate() -> TKStateMachine {
        stateMachine.addStates([searchingState, hasReceivedInvitationsState, hasSelectedInvitationState, hasAcceptedInvitationState, connectedState])
        stateMachine.addEvents([invitationFoundEvent, invitationSelectedEvent, invitationAcceptedEvent, hasConnectedEvent, connectionLostEvent])
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
        case hasReceivedInvitationsStateName: hasReceivedInvitationsState.setDidEnterStateBlock(privateBlock)
        case hasSelectedInvitationStateName: hasSelectedInvitationState.setDidEnterStateBlock(privateBlock)
        case hasAcceptedInvitationStateName: hasAcceptedInvitationState.setDidEnterStateBlock(privateBlock)
        case connectedStateName: connectedState.setDidEnterStateBlock(privateBlock)
        default: NSLog("StateName didn't match.")
        }
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