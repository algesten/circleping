//
//  main.swift
//  SimplePing
//
//  Created by Martin Algesten on 20/12/14.
//  Copyright (c) 2014 Repsio Ltd. All rights reserved.
//

import Foundation
import Cocoa

// Info.Plist loading to get the main NSApplication subclass
let dic:NSDictionary = NSBundle.mainBundle().infoDictionary!;
let princStr = dic.objectForKey("NSPrincipalClass") as NSString!;
let princ:AnyClass = NSClassFromString(princStr)!;

// here is the shared app
var app:NSApplication = princ.sharedApplication();

// create and retain delegate reference;
var delegate = AppDelegate();
// set our delegate;
app.delegate = delegate;

// and wait for it to finish;
app.run();
