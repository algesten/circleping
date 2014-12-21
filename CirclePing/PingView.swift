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
 
    var statusItem:NSStatusItem
    var images:[NSImage]
    
    init() {
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        images = [NSImage]()
        for i in 0...5 {
            let img = NSImage(named:"status\(i)")!
            img.setTemplate(true)
            images.append(img)
        }
    }
    
    public func updatePing(packetLoss:Double, roundTrip:Double) {
        let bracket = Int(ceil(packetLoss/0.2))
        assert(bracket >= 0, "bracket < 0!")
        assert(bracket <= 5, "bracket > 5!")
//        println("update \(packetLoss) \(roundTrip) \(bracket)")
        statusItem.image = images[5 - bracket]
    }

    deinit {
        NSStatusBar.systemStatusBar().removeStatusItem(statusItem)
    }
    
}