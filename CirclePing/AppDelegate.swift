//
//  AppDelegate.swift
//  CirclePing
//
//  Created by Martin Algesten on 20/12/14.
//  Copyright (c) 2014 Repsio Ltd. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let pingModel = PingModel()
    let pingView = PingView()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        println("launch")
        pingModel.delegate = pingView;
        pingModel.host = "8.8.8.8"
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        println("terminate")
    }


}

