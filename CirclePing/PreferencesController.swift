//
//  PreferencesController.swift
//  CirclePing
//
//  Created by Martin Algesten on 21/12/14.
//  Copyright (c) 2014 Repsio Ltd. All rights reserved.
//

import Foundation
import Cocoa

let WIDTH  = 400.0
let HEIGHT = 130.0

public class PreferencesController : NSViewController, NSWindowDelegate {
    
    var win:NSWindow?
    
    public required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    override init!(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience override init() {
        self.init(nibName: "PingUI", bundle: nil)
    }
    
    public func show(orig:CGPoint) {
        if win == nil {
            let x = Double(orig.x) - WIDTH / 2
            let y = Double(orig.y) - HEIGHT - 30
            let pos = NSRect(x:x,y:y,width:WIDTH,height:HEIGHT)
            win = NSWindow(contentRect: pos, styleMask:(NSTitledWindowMask | NSClosableWindowMask), backing: NSBackingStoreType.Buffered, defer: false)
            win!.delegate = self
            // not release directly since that crashes
            win!.releasedWhenClosed = false
            win!.title = "Circle Ping"
            win!.contentView = self.view
            self.view.frame = NSRect(x:0,y:0,width:WIDTH,height:HEIGHT)
        }
        NSApp.activateIgnoringOtherApps(true)
        win!.makeKeyAndOrderFront(self)
    }


    public func windowWillClose(notification: NSNotification) {
        if let locWin = win {
            win = nil
            // ensure window releases
            locWin.close()
        }
    }
    
}