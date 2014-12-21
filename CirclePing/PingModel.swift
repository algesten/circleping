//
//  PingModel.swift
//  CirclePing
//
//  Created by Martin Algesten on 20/12/14.
//  Copyright (c) 2014 Repsio Ltd. All rights reserved.
//

import Foundation

// size of array
let SCHLEPP = 1
let SIZE = 12 + (SCHLEPP + 1) // 1 current

let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

public protocol PingModelDelegate {
    func updatePing(packetLoss:Double, roundTrip:Double)
}

public class PingModel : NSObject, SimplePingDelegate {
    
    public var host:String? {
        didSet {
            initPinger()
        }
    }
    public var delegate:PingModelDelegate?;
    
    var timer:dispatch_source_t?
    var pinger:SimplePing?
    var responses = [Int](count:SIZE, repeatedValue:1)
    var packetLoss:Double = 0.0
    var roundTrip:Double = 0.0  // in millis
    
    func initPinger() {
        // stop previous pinger
        stop()
        pinger = SimplePing(hostName:host)
        pinger!.delegate = self
        pinger!.start()
    }

    func pingAndMeasure() {
        if pinger != nil {
            let seq = Int(pinger!.nextSequenceNumber)
            let i:Int = seq % SIZE
            // microseconds
            let now = Int(CACurrentMediaTime() * 1000000)
            responses[i] = now
            // do ping
            pinger!.sendPingWithData(nil)
            // measure SCHLEPP seconds behind current sequence
            let head = (seq - SCHLEPP) % SIZE
            let tail = (seq - SIZE + 1) % SIZE
            measure(head, tail:tail)
        } else {
            stop()
        }
    }
    
    func isReceived(t:Int) -> Bool {
        return t < (15 * 1000000);
    }
    
    func measure(var head:Int, var tail:Int) {
        var count = 0
        var totalTime = 0
        var total = 0
        if (head < 0) {
            head = 0
        }
        if (tail < 0) {
            tail = 0
        }
        if (head < tail) {
            for i in 0..<head {
                if (isReceived(responses[i])) {
                    totalTime += responses[i]
                    count++
                }
                total++
            }
            for i in tail..<responses.count {
                if (isReceived(responses[i])) {
                    totalTime += responses[i]
                    count++
                }
                total++
            }
        } else {
            for i in tail..<head {
                if (isReceived(responses[i])) {
                    totalTime += responses[i]
                    count++
                }
                total++
            }
        }
        if (total) > 0 {
            packetLoss = Double(total - count) / Double(total)
            // in millis
            roundTrip = Double(totalTime / total) * 1000.0
        }
        dispatch_async(dispatch_get_main_queue(), {[weak self] ()->() in
            if let this = self {
                if let delegate = this.delegate {
                    delegate.updatePing(this.packetLoss, roundTrip: this.roundTrip)
                }
            }
        })
    }
    
    func startTimer() {
        println("start timer")
        // use GCD to not get backgrounded with NSTimer
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_timer(timer!, dispatch_time(DISPATCH_TIME_NOW, 0), 1000 * NSEC_PER_MSEC, 10 * NSEC_PER_MSEC)
        dispatch_source_set_event_handler(timer!, {[weak self] ()->() in
            if let this = self {
                this.pingAndMeasure()
            }
        })
        dispatch_resume(timer)
    }
    
    func stop() {
        println("stop timer")
        if timer != nil {
            dispatch_source_cancel(timer)
            timer = nil
        }
        println("stop pinger")
        if pinger != nil {
            pinger!.stop()
            pinger!.delegate = nil
            pinger = nil
        }
    }

    public func simplePing(pinger: SimplePing!, didStartWithAddress address: NSData!) {
        println("start with " + pinger.displayAddressForAddress(address))
        startTimer()
    }
    public func simplePing(pinger: SimplePing!, didFailWithError error: NSError!) {
        println("fail")
    }
    public func simplePing(pinger: SimplePing!, didFailToSendPacket packet: NSData!, error: NSError!) {
        // disconnecting the network comes here
        // println("fail to send")
    }
    public func simplePing(pinger: SimplePing!, didSendPacket packet: NSData!) {
        //println("did send")
    }
    public func simplePing(pinger: SimplePing!, didReceivePingResponsePacket packet: NSData!) {
        let seq:UInt16 = pinger.sequenceNumberForPacket(packet)
        let i:Int = Int(seq) % SIZE
        // microseconds
        let now = Int(CACurrentMediaTime() * 1000000)
        responses[i] = now - responses[i]
        // println("did receive response \(responses[i])")
    }
    public func simplePing(pinger: SimplePing!, didReceiveUnexpectedPacket packet: NSData!) {
        // any ping response packet the host receives that we didnt send
        // ends up here.
        //        println("did receive unexpected")
    }
}
