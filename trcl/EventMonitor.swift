//
//  EventMonitor.swift
//  trcl
//
//  Created by Tom Kazakov on 11/3/17.
//  Copyright © 2017 Tom Kazakov. All rights reserved.
//

import Cocoa

class EventMonitor {
    
    var mask: NSEventMask
    var handler: (NSEvent?) -> ()
    
    var monitor: Any?
    // TODO: check for "you need to keep a reference to it so you can dismiss it when you no longer need it. (If you don’t, you get a – tiny – memory leak.)"
    
    init(mask: NSEventMask, handler: @escaping (NSEvent?) -> ()){
        self.mask = mask
        self.handler = handler
    }

    deinit{
        stop()
    }
    
    func start(){
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    func stop(){
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
    

}
