//
//  AppDelegate.swift
//  trcl
//
//  Created by Tyoma Kazakov on 19.07.16.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    var timer = NSTimer()
    
    let tzz = ["America/Los_Angeles", "America/New_York", "Europe/Moscow"]
    
    var ftz = ""

    
    @IBAction func applicationDidFinishLaunching(aNotification: NSNotification) {
        
//        statusItem.title = ""
        statusItem.menu = statusMenu
        
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        
        for tz in tzz {
            print(isLocal(tz))
        }

        
    }

    @IBAction func menuClicked(sender: NSMenuItem) {
        
        
    }
    

    func timerAction() {
        
        // PDT EDT MSK

        ftz = ""

        for (index, tz) in tzz.enumerate() {
            
            if isLocal(tz) {
                ftz += formatTime(tz, local: true) + " " + getDate()
            }
            else {
                ftz += formatTime(tz, local: false)
            }
            
            if index != tzz.count {
                ftz += " "
            }
            
            
        }
        
        
        statusItem.title = ftz
    }
    

    
    func formatTime(tz: String, local: Bool) -> String {
        
        let formatter = NSDateFormatter()
        if local {
           formatter.dateFormat = "h:mma"
        } else {
           formatter.dateFormat = "ha"
        }
    
        formatter.timeZone = NSTimeZone(name: tz)
        
        return formatter.stringFromDate(NSDate())
    }
    
    
    func isLocal(tz: String) -> Bool {
    
        return NSTimeZone.localTimeZone().name == tz
        
    }
    
    
    func getDate() -> String { //    TODO: вообще-то это нет смысла вычислять два раза за секунду
        let currentDate = NSDate()
        let usDateFormat = NSDateFormatter()
        usDateFormat.dateFormat = "MMM d, EEEEEE"
        usDateFormat.locale = NSLocale(localeIdentifier: "en-US")
        return usDateFormat.stringFromDate(currentDate)
    }
    

}



