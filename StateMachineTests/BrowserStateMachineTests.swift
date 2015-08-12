//
//  StateMachineTests.swift
//  StateMachineTests
//
//  Created by Mathias Köhnke on 12/08/15.
//  Copyright (c) 2015 Mathias Köhnke. All rights reserved.
//

import UIKit
import XCTest

class StateMachineTests: XCTestCase {
    
    var stateMachine : BrowserStateMachine!
    
    override func setUp() {
        super.setUp()
        stateMachine = BrowserStateMachine()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testPeerFoundEvent() {
        let foundPeer1 = Peer(name: "Peer1", currentState: .Found)
        stateMachine.peerFound(foundPeer1)
        
        let foundPeer2 = Peer(name: "Peer2", currentState: .Found)
        stateMachine.peerFound(foundPeer2)
        
        XCTAssert(stateMachine.currentState == stateMachine.hasFoundPeersStateName &&
            stateMachine.numberOfPeers(.Found) == 2, "Pass")
    }
    
    func testPeerInvitedEvent() {
        let peer = Peer(name: "Peer1", currentState: .Found)
        stateMachine.peerFound(peer)
        stateMachine.peerInvited(peer)
        
        XCTAssert(stateMachine.currentState == stateMachine.hasInvitedPeersStateName &&
            stateMachine.numberOfPeers(.Invited) == 1, "Pass")
    }
    
    func testPeerConnectedEvent() {
        let peer = Peer(name: "Peer1", currentState: .Found)
        stateMachine.peerFound(peer)
        stateMachine.peerInvited(peer)
        stateMachine.peerConnected(peer)
        
        XCTAssert(stateMachine.currentState == stateMachine.hasConnectedPeersStateName &&
            stateMachine.numberOfPeers(.Connected) == 1, "Pass")
    }
    
    func testConnectedPeerDisconnectedEvent() {
        let peer = Peer(name: "Peer1", currentState: .Found)
        stateMachine.peerFound(peer)
        stateMachine.peerInvited(peer)
        stateMachine.peerConnected(peer)
        stateMachine.peerDisconnected(peer)
        
        XCTAssert(stateMachine.currentState == stateMachine.searchingStateName &&
            stateMachine.numberOfPeers(.Found) == 0 &&
            stateMachine.numberOfPeers(.Invited) == 0 &&
            stateMachine.numberOfPeers(.Connected) == 0, "Pass")
    }
    
    func testInvitedPeerLostEvent() {
        let peer = Peer(name: "Peer1", currentState: .Found)
        stateMachine.peerFound(peer)
        stateMachine.peerInvited(peer)
        stateMachine.peerDisconnected(peer)
        
        XCTAssert(stateMachine.currentState == stateMachine.searchingStateName &&
            stateMachine.numberOfPeers(.Found) == 0 &&
            stateMachine.numberOfPeers(.Invited) == 0 &&
            stateMachine.numberOfPeers(.Connected) == 0, "Pass")
    }
    
    func testFoundPeerLostEvent() {
        let peer = Peer(name: "Peer1", currentState: .Found)
        stateMachine.peerFound(peer)
        stateMachine.peerDisconnected(peer)
        
        XCTAssert(stateMachine.currentState == stateMachine.searchingStateName &&
            stateMachine.numberOfPeers(.Found) == 0 &&
            stateMachine.numberOfPeers(.Invited) == 0 &&
            stateMachine.numberOfPeers(.Connected) == 0, "Pass")
    }
    
    private func printState() {
        NSLog("Current state: %@", stateMachine.currentState)
        NSLog("Peers: Found(%d), Invited(%d), Connected(%d)", stateMachine.numberOfPeers(.Found), stateMachine.numberOfPeers(.Invited), stateMachine.numberOfPeers(.Connected))
    }
    
}
