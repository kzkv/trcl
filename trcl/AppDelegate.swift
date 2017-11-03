//
//  AppDelegate.swift
//  trcl
//
//  Created by Tyoma Kazakov on 19.07.16.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

// TODO: autostart

import Cocoa
import Foundation
import ServiceManagement


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Current bundle name to a constant
    let APPNAME = Bundle.main.infoDictionary!["CFBundleName"] as! String

    @IBOutlet weak var mainMenu: NSMenu!
    var mainMenuDelegate = MainMenuDelegate()

    let mainStatusItem = NSStatusBar.system().statusItem(withLength: -1)
    
    var timer = Timer()    
    var starterTimer = Timer()
    
    
    let popover = NSPopover()
    // popover window
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // declaring button made of StatusItem
        let button = mainStatusItem.button

        
        tzResearch()
                
        // Assaigning a delegate to the mainMenu object
//        mainMenu.delegate = mainMenuDelegate
        
        mainStatusItem.menu = mainMenu
        
//        NSLog(mainMenu.delegate as! String)
        
        currentDateString = getDate()
        
        setTimeZones()
        
        UserDefaults.standard.register(defaults: [
            use24HForLocalTZ : false,
            displayDateForLocalTZ : true,
//            autostart: false
            ])
        
        starterTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(starterTimerAction), userInfo: nil, repeats: true)
        
        // Getting a notification on a date change
        NotificationCenter.default.addObserver(forName:Notification.Name.NSCalendarDayChanged,
                                               object:nil, queue:nil, using:calendarDayDidChange)

        
        // popover activation
        popover.contentViewController = PopoverViewController(nibName: "PopoverViewController", bundle: nil)
        popover.animates = false
        
        
        // uses "button" made of statusmenu item
//        popover.show(relativeTo: button!.bounds, of: button!, preferredEdge: NSRectEdge.maxY)

        button?.action = #selector(AppDelegate.togglePopover(sender:))
        
    }
    
    // popover management
    func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = mainStatusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    
    // Setting main timer in sync with system clock
    func starterTimerAction() {
        let currentTime = NSDate().timeIntervalSince1970
        var integer = 0.0
        let fraction = modf(currentTime, &integer)
        let rounded = Double(round(10*fraction)/10)
        
        if rounded == 0.00 {
            starterTimer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    // Main timer proc
    func timerAction() {
        // Aggregate and format main string
        let ftz = NSMutableAttributedString(string: "")
        
        var nonvisibleCounter: Int = 0
        var previousWasLocal: Bool = false
        
        var font: NSFont
        
        font = NSFont.menuBarFont(ofSize: 10)
        //                        font = NSFont(name: name, size: pointSize) ?? systemFont
        let fontManager = NSFontManager.shared()
        font = fontManager.convert(font, toHaveTrait: .smallCapsFontMask)
        let ampmFontAttr = [ NSFontAttributeName: font ]
        
        let timeFontAttr = [ NSFontAttributeName: NSFont.menuBarFont(ofSize: 0) ]
        //        let dateFontAttr = [ NSFontAttributeName: NSFont.menuBarFontOfSize(10) ]
        
        //        let notLocalFontAttr = [ NSForegroundColorAttributeName: NSColor.gray ]
        // TODO: text gets weird outline with coloring
        
        
        
        for (index, tz) in timeZones.enumerated() {
            
            var timeArray: [String] = ["",""]
            //            var timeAttrString = NSAttributedString(string: "", attributes: timeFontAttributes)
            
            if tz.isLocal() == true {
                if previousWasLocal != true {

                
                timeArray = formatTime(tz.name, local: true)
                
                ftz.append(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                ftz.append(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
                ftz.append(NSAttributedString(string: " ", attributes: ampmFontAttr))
                
                if defaults.bool(forKey: displayDateForLocalTZ) == true {
                    ftz.append(NSAttributedString(string: currentDateString, attributes: ampmFontAttr))
                }
                
                previousWasLocal = true
                }
            }
            else {
                if defaults.bool(forKey: tz.name+"Visible") == true {
                    if previousWasLocal == true {
                        ftz.append(NSAttributedString(string: " ", attributes: ampmFontAttr))
                    }
                    
                    timeArray = formatTime(tz.name, local: false)
                    
//                    let rangeStart = ftz.length
                    
                    ftz.append(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                    ftz.append(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
//                    ftz.addAttributes(notLocalFontAttr, range: NSMakeRange(rangeStart, ftz.length-rangeStart))
                    
                    if index != timeZones.count {
                        ftz.append(NSAttributedString(string: " ", attributes: ampmFontAttr))
                    }
                    
                    previousWasLocal = false
                }
                else {
                    nonvisibleCounter += 1
                }
            }
        }
        
        if nonvisibleCounter == timeZones.endIndex {
            // Incrementing counter to avoid empty string
            ftz.append(NSAttributedString(string: "trcl", attributes: timeFontAttr))
        }
        
        mainStatusItem.attributedTitle = ftz
    }
    

    // Array of time/date values for the main string
    func formatTime(_ timeZone: String, local: Bool) -> Array<String> {
        
        let timeFormatter = DateFormatter()
        let ampm = DateFormatter()
        
        var timeArray: [String] = ["",""]
        
        if local {
            if defaults.bool(forKey: use24HForLocalTZ) == true {
                timeFormatter.dateFormat = "H:mm"
                ampm.dateFormat = ""
            }
            else {
                timeFormatter.dateFormat = "h:mm"
                ampm.dateFormat = "a"
            }
        }
        else {
            timeFormatter.dateFormat = "h"
            ampm.dateFormat = "a"
        }
        
        timeFormatter.timeZone = TimeZone(identifier: timeZone)
        ampm.timeZone = TimeZone(identifier: timeZone)
        
        timeArray[0] = timeFormatter.string(from: Date())
        timeArray[1] = ampm.string(from: Date())
        
        return timeArray
    }
    
    
    // Initializing timezones set via timezones list const
    func setTimeZones() {
        
        var addedTimezone: TRTimeZone
        
        for (_, tz) in STtimeZones.enumerated() {
            addedTimezone = TRTimeZone.init(name: tz)
            timeZones.append(addedTimezone)
            
            // Populating defaults with visibility settings
            UserDefaults.standard.register(defaults: [addedTimezone.name+"Visibile" : false])
        }
    }
}
