//
//  AppDelegate.swift
//  trcl
//
//  Created by Tyoma Kazakov on 19.07.16.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

import Cocoa
import Foundation
import AppKit


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    var timer = NSTimer()
    
    // To be replaced by persistable settings
    let STtimeZones = ["America/Los_Angeles", "America/New_York", "Europe/Moscow"]
    let STrus24H = true
    
    
    // Russian timezone for lookup when user settings are to use 24H/military there
    let RUS_TZ = "Europe/Moscow"
    
    
    // Font attributes
    let ampmFontAttr = [ NSFontAttributeName: NSFont.menuBarFontOfSize(10) ]
    let timeFontAttr = [ NSFontAttributeName: NSFont.menuBarFontOfSize(0) ]
    let dateFontAttr = [ NSFontAttributeName: NSFont.menuBarFontOfSize(10) ]
    let notLocalFontAttr = [ NSForegroundColorAttributeName: NSColor.grayColor() ]

    
    
    @IBAction func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        //        statusItem.title = ""
        statusItem.menu = statusMenu
        
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func menuClicked(sender: NSMenuItem) {
        
        
    }
    
    // TODO: исправить внешний вид шрифта при нажатой кнопке
    // TODO: перейти на attributed для button-statusmenu
    
    func timerAction() {
        
        // PDT EDT MSK
        
        let ftz = NSMutableAttributedString(string: "")
        
        for (index, tz) in STtimeZones.enumerate() {
            
            var timeArray: [String] = ["",""]
        
//            var timeAttrString = NSAttributedString(string: "", attributes: timeFontAttributes)

            
            if isLocal(tz) {
                timeArray = formatTime(tz, local: true)
                
                ftz.appendAttributedString(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                ftz.appendAttributedString(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
                ftz.appendAttributedString(NSAttributedString(string: " ", attributes: ampmFontAttr))
                ftz.appendAttributedString(NSAttributedString(string: getDate(), attributes: dateFontAttr))
                // TODO: отключаемая дата

            }
            else {
                timeArray = formatTime(tz, local: false)
                
                let rangeStart = ftz.length
                
                ftz.appendAttributedString(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                ftz.appendAttributedString(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
                ftz.addAttributes(notLocalFontAttr, range: NSMakeRange(rangeStart, ftz.length-rangeStart))
                
            }

            if index != STtimeZones.count {
                ftz.appendAttributedString(NSAttributedString(string: " ", attributes: ampmFontAttr))
            }
            
            
        }
        
        
        statusItem.attributedTitle = ftz
    }
    
    
    // Array of time strings
    func formatTime(timeZone: String, local: Bool) -> Array<String> {
        
        let timeFormatter = NSDateFormatter()
        let ampm = NSDateFormatter()
        
        var timeArray: [String] = ["",""]
        
        
        if STrus24H == true && timeZone == RUS_TZ {
            if local {
                timeFormatter.dateFormat = "H:mm"
                ampm.dateFormat = ""
            }
            else {
                timeFormatter.dateFormat = "h"
                ampm.dateFormat = "a"
            }
            
        }
        else {
            if local {
                timeFormatter.dateFormat = "h:mm"
            }
            else {
                timeFormatter.dateFormat = "h"
            }
            
            ampm.dateFormat = "a"
            
        }
        
        timeFormatter.timeZone = NSTimeZone(name: timeZone)
        ampm.timeZone = NSTimeZone(name: timeZone)
        
        timeArray[0] = timeFormatter.stringFromDate(NSDate())
        timeArray[1] = ampm.stringFromDate(NSDate())
        
        return timeArray
    }
    
    
    func isLocal(tz: String) -> Bool {
        
        return NSTimeZone.localTimeZone().name == tz
        
    }
    
    
    func getDate() -> String { //    TODO: вообще-то это нет смысла вычислять два раза за секунду
        let usDateFormat = NSDateFormatter()
        usDateFormat.dateFormat = "MMM d"
        usDateFormat.locale = NSLocale(localeIdentifier: "en-US")
        return usDateFormat.stringFromDate(NSDate())
    }
    
    
}



