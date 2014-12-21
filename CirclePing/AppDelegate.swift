//
//  AppDelegate.swift
//  CirclePing
//
//  Created by Martin Algesten on 20/12/14.
//  Copyright (c) 2014 Repsio Ltd. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let pingView = PingView()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        println("launch")
        PingModel.sharedInstance.delegate = pingView;
        let defs = NSUserDefaults.standardUserDefaults()
        var host = defs.stringForKey("host")
        if host == nil {
            host = "8.8.8.8"
            defs.setValue(host, forKey: "host")
        }
        PingModel.sharedInstance.host = host!
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        PingModel.sharedInstance.stop()
        println("terminate")
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return false
    }

}

