//
//  PingView.swift
//  CirclePing
//
//  Created by Martin Algesten on 20/12/14.
//  Copyright (c) 2014 Repsio Ltd. All rights reserved.
//

import Foundation
import Cocoa

public class PingView : PingModelDelegate {
 
    var statusItem:NSStatusItem? = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    public func updatePing(packetLoss:Double, roundTrip:Double) {
        println("update \(packetLoss) \(roundTrip)")
    }

    deinit {
        if (statusItem != nil) {
            NSStatusBar.systemStatusBar().removeStatusItem(statusItem!)
        }
        statusItem = nil
    }
    
}