//
//  AdvertiserStateMachineTests.swift
//  StateMachine
//
//  Created by Mathias Köhnke on 13/08/15.
//  Copyright (c) 2015 Mathias Köhnke. All rights reserved.
//

import UIKit
import XCTest

class AdvertiserStateMachineTests: XCTestCase {

    var stateMachine : AdvertiserStateMachine!
    
    override func setUp() {
        super.setUp()
        stateMachine = AdvertiserStateMachine()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testInvitationFoundEvent() {
        let foundPeer1 = Peer(name: "Peer1")
        stateMachine.invitationFound(foundPeer1)
        
        let foundPeer2 = Peer(name: "Peer2")
        stateMachine.invitationFound(foundPeer2)
        
        TestHelper.printState(stateMachine)
        
        XCTAssert(stateMachine.currentState == stateMachine.hasReceivedInvitationsStateName &&
            stateMachine.numberOfPeers(.Found) == 2, "Pass")
    }

    
    func testInvitationSelectedEvent() {
        let peer = Peer(name: "Peer1")
        stateMachine.invitationFound(peer)
        stateMachine.invitationSelected(peer)
        
        TestHelper.printState(stateMachine)
        
        XCTAssert(stateMachine.currentState == stateMachine.hasSelectedInvitationStateName &&
            stateMachine.numberOfPeers(.Selected) == 1, "Pass")
    }
    
    
    func testInvitationAcceptedEvent() {
        let peer = Peer(name: "Peer1")
        stateMachine.invitationFound(peer)
        stateMachine.invitationSelected(peer)
        stateMachine.invitationAccepted(peer)
        
        TestHelper.printState(stateMachine)
        
        XCTAssert(stateMachine.currentState == stateMachine.hasAcceptedInvitationStateName &&
            stateMachine.numberOfPeers(.Accepted) == 1, "Pass")
    }
    
    func testHasConnectedEvent() {
        let peer = Peer(name: "Peer1")
        stateMachine.invitationFound(peer)
        stateMachine.invitationSelected(peer)
        stateMachine.invitationAccepted(peer)
        stateMachine.hasConnected(peer)
        
        TestHelper.printState(stateMachine)
        
        XCTAssert(stateMachine.currentState == stateMachine.connectedStateName &&
            stateMachine.numberOfPeers(.Connected) == 1, "Pass")
    }
    
    
    func testFoundInvitationLostEvent() {
        let peer = Peer(name: "Peer1")
        stateMachine.invitationFound(peer)
        stateMachine.connectionLostEvent(peer)
        
        TestHelper.printState(stateMachine)
        
        XCTAssert(stateMachine.currentState == stateMachine.searchingStateName &&
            stateMachine.numberOfPeers(.Found) == 0 && stateMachine.peers.count == 0, "Pass")
    }
    
    func testSelectedInvitationLostEvent() {
        let peer = Peer(name: "Peer1")
        stateMachine.invitationFound(peer)
        stateMachine.invitationSelected(peer)
        stateMachine.connectionLostEvent(peer)
        
        TestHelper.printState(stateMachine)
        
        XCTAssert(stateMachine.currentState == stateMachine.searchingStateName &&
            stateMachine.numberOfPeers(.Selected) == 0 && stateMachine.peers.count == 0, "Pass")
    }

    
    func testAcceptedInvitationLostEvent() {
        let peer = Peer(name: "Peer1")
        stateMachine.invitationFound(peer)
        stateMachine.invitationSelected(peer)
        stateMachine.invitationAccepted(peer)
        stateMachine.connectionLostEvent(peer)
        
        TestHelper.printState(stateMachine)
        
        XCTAssert(stateMachine.currentState == stateMachine.searchingStateName &&
            stateMachine.numberOfPeers(.Accepted) == 0 && stateMachine.peers.count == 0, "Pass")
    }
    
    func testConnectionLostEvent() {
        let peer = Peer(name: "Peer1")
        stateMachine.invitationFound(peer)
        stateMachine.invitationSelected(peer)
        stateMachine.invitationAccepted(peer)
        stateMachine.hasConnected(peer)
        stateMachine.connectionLostEvent(peer)
        
        TestHelper.printState(stateMachine)
        
        XCTAssert(stateMachine.currentState == stateMachine.searchingStateName &&
            stateMachine.numberOfPeers(.Connected) == 0 && stateMachine.peers.count == 0, "Pass")
    }
}
