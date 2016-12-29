//
//  AppDelegate.swift
//  trcl
//
//  Created by Tyoma Kazakov on 19.07.16.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

// TODO: autostart
// TODO: исправить внешний вид шрифта при нажатой кнопке
// TODO: перейти на attributed для button-statusmenu

import Cocoa
import Foundation
import ServiceManagement


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Current bundle name to a constant
    let APPNAME = Bundle.main.infoDictionary!["CFBundleName"] as! String

    @IBOutlet weak var statusMenu: NSMenu!
//    var statusMenu = NSMenu(title: "Status Menu")
    
    // NSMenuDelegate call
    
    let mainStatusItem = NSStatusBar.system().statusItem(withLength: -1)
    
    var timer = Timer()    
    var starterTimer = Timer()
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        currentDateString = getDate()
        
        setTimeZones()
        
        UserDefaults.standard.register(defaults: [
            use24HForLocalTZ : false,
            displayDateForLocalTZ : true,
//            autostart: false
            ])
        
        starterTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(starterTimerAction), userInfo: nil, repeats: true)
        
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
        
        // Set current date each new hour
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)

        if (minutes == 0 && seconds == 0) {
            currentDateString = getDate()
            NSLog(currentDateString)
        }
        
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
        let notLocalFontAttr = [ NSForegroundColorAttributeName: NSColor.gray ]
        
        
        for (index, tz) in timeZones.enumerated() {
            
            var timeArray: [String] = ["",""]
            //            var timeAttrString = NSAttributedString(string: "", attributes: timeFontAttributes)
            
            if tz.isLocal() == true {
                timeArray = formatTime(tz.name, local: true)
                
                ftz.append(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                ftz.append(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
                ftz.append(NSAttributedString(string: " ", attributes: ampmFontAttr))
                
                if defaults.bool(forKey: displayDateForLocalTZ) == true {
                    ftz.append(NSAttributedString(string: currentDateString, attributes: ampmFontAttr))
                }
                
                previousWasLocal = true
                
            }
            else {
                if defaults.bool(forKey: tz.name+"Visible") == true {
                    if previousWasLocal == true {
                        ftz.append(NSAttributedString(string: " ", attributes: ampmFontAttr))
                    }
                    
                    timeArray = formatTime(tz.name, local: false)
                    
                    let rangeStart = ftz.length
                    
                    ftz.append(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                    ftz.append(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
                    ftz.addAttributes(notLocalFontAttr, range: NSMakeRange(rangeStart, ftz.length-rangeStart))
                    
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

    func getDate() -> String { //    TODO: вообще-то это нет смысла вычислять два раза за секунду
        let usDateFormat = DateFormatter()
        usDateFormat.dateFormat = "MMM d"
        usDateFormat.locale = Locale(identifier: "en-US")
        return usDateFormat.string(from: Date())
    }
    
}
