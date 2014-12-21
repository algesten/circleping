//
//  PingView.swift
//  CirclePing
//
//  Created by Martin Algesten on 20/12/14.
//  Copyright (c) 2014 Repsio Ltd. All rights reserved.
//

import Foundation
import Cocoa

public class PingView : NSObject, PingModelDelegate, NSMenuDelegate {
 
    let prefs = PreferencesController()
    var statusItem:NSStatusItem
    var images:[NSImage]
    var menu:NSMenu
    
    override public init() {
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        var arr:NSArray?
        NSBundle.mainBundle().loadNibNamed("PingUI", owner: nil, topLevelObjects:&arr)
        menu = filter(arr as [AnyObject]) { $0 is NSMenu }[0] as NSMenu
        statusItem.menu = menu
        images = [NSImage]()
        for i in 0...5 {
            let img = NSImage(named:"status\(i)")!
            img.setTemplate(true)
            images.append(img)
        }
        super.init()
        for item in menu.itemArray as [NSMenuItem] {
            item.target = self
            item.action = "onMenuClick:"
        }
    }
    
    public func onMenuClick(sender:NSMenuItem) {
        let tag = sender.tag
        if tag == 1 {
            // preferences
            let window = statusItem.valueForKey("window")! as NSWindow
            let scr = window.frame
            prefs.show(scr.origin)
        } else if tag == 2 {
            // quit
            NSApplication.sharedApplication().terminate(self)
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