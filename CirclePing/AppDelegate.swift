//
//  AppDelegate.swift
//  CirclePing
//
//  Created by Martin Algesten on 20/12/14.
//  Copyright (c) 2014 Repsio Ltd. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem:NSStatusItem?;
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        println("launch");
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1);
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        if (statusItem != nil) {
            NSStatusBar.systemStatusBar().removeStatusItem(statusItem!);
        }
        statusItem = nil;
        println("terminate");
    }


}

