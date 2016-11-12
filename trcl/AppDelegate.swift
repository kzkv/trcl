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
    
    // Current bundle name to a constant
    let APPNAME = Bundle.main.infoDictionary!["CFBundleName"] as! String


    
    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
    }
    
    
    let mainStatusItem = NSStatusBar.system().statusItem(withLength: -1)
    
    var timer = Timer()
    
    // TODO: persistable settings
    let defaults = UserDefaults.standard
    let use24HForLocalTZ = "use24HForLocalTZ"
    let displayDateForLocalTZ = "displayDateForLocalTZ"
    

    let STtimeZones = [
//                        "America/Nome", //-11 Sic! Possibly not a principle city
                        "Pacific/Honolulu", //-10
                        "America/Anchorage", //-9
                        "America/Los_Angeles", //-8
                        "America/Phoenix", //-7
                        "America/Chicago", //-6
                        "America/New_York", //-5
                        "America/Santiago", //-4
                        "America/Sao_Paulo", //-3
//                        "America/Noronha", //-2 Sic! Possibly not a principle city
                        "Atlantic/Cape_Verde", //-1
                        "Europe/London", //0
                        "Europe/Berlin", //1
                        "Asia/Jerusalem", //2 Sic! Possibly not a principle city
                        "Europe/Moscow", //3 Sic! Daylight saving
                        "Asia/Dubai", //4
                        "Asia/Yekaterinburg", //5 Sic! Possibly not a principle city
                        "Asia/Omsk", //6
                        "Asia/Jakarta", //7 Sic! Possibly not a principle city
                        "Asia/Singapore", //8 Sic! Didn't find Beijing on the list
                        "Asia/Tokyo", //9
                        "Australia/Sydney", //10
//                        "Pacific/Noumea", //11 Sic! Possibly not a principle city
                        "Pacific/Fiji" //12
    ]

//    let STtimeZones = NSTimeZone.knownTimeZoneNames
    let tzlist = NSTimeZone.knownTimeZoneNames
    
    var STshowDate = true
    
    
    // Time zone array
    var timeZones = [TRTimeZone]()
    
    // Local timezone object 
    var localTimeZone = TRTimeZone(name: TimeZone.autoupdatingCurrent.identifier, local: true, visible: false)
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        setTimeZones()
        buildMenu()
        
//        print(tzlist)
        
        // TODO: proper defaults settings for the shipped bundle
        setDefaults()
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func menuClicked(_ sender: NSMenuItem) {
        
        
    }
    
    //TODO: выводить в дроп-дауне текущие дату-время-день недели для каждой таймзоны
    
    //TODO: добавить +/- для предыдущего следующего дня
    
    // TODO: исправить внешний вид шрифта при нажатой кнопке
    // TODO: перейти на attributed для button-statusmenu
    
    func timerAction() {

        setLocal()
        buildMenu()
        
        let ftz = NSMutableAttributedString(string: "")
        
        var nonvisibleCounter: Int = 0
        
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

            if tz.visible == true {
                if tz.local == true {
                    timeArray = formatTime(tz.name, local: true)

                    ftz.append(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                    ftz.append(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
                    ftz.append(NSAttributedString(string: " ", attributes: ampmFontAttr))
                    
                    if defaults.bool(forKey: displayDateForLocalTZ) == true {
                        ftz.append(NSAttributedString(string: getDate(), attributes: ampmFontAttr))
                    }

                }
                else {
                    timeArray = formatTime(tz.name, local: false)
                    
                    let rangeStart = ftz.length
                    
                    ftz.append(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                    ftz.append(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
                    ftz.addAttributes(notLocalFontAttr, range: NSMakeRange(rangeStart, ftz.length-rangeStart))
                    
                }

                if index != timeZones.count {
                    ftz.append(NSAttributedString(string: " ", attributes: ampmFontAttr))
                }
            } else {
                nonvisibleCounter += 1
            }
            
        }
        
        if nonvisibleCounter == timeZones.endIndex {
            // Incrementing counter to avoid empty string
            ftz.append(NSAttributedString(string: "trcl", attributes: timeFontAttr))
        }
        
        mainStatusItem.attributedTitle = ftz
    }
    
    
    // Array of time strings
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
    
    
    func isLocal(_ tz: String) -> Bool {
        
        return TimeZone.autoupdatingCurrent.identifier == tz
        
    }
    
    func setLocal() {
        
        localTimeZone.name = TimeZone.autoupdatingCurrent.identifier
        
        for (_,tz) in timeZones.enumerated() {
            tz.local = false
            
            if tz.offset() == localTimeZone.offset() {
                tz.local = true
            }
        }
        
    }
    
    
    func getDate() -> String { //    TODO: вообще-то это нет смысла вычислять два раза за секунду
        let usDateFormat = DateFormatter()
        usDateFormat.dateFormat = "MMM d"
        usDateFormat.locale = Locale(identifier: "en-US")
        return usDateFormat.string(from: Date())
    }
    
    
    //TODO: call buildMenu only on user action (click on mainStatusItem)
    func buildMenu() {
        
        var statusItem = NSMenuItem()
        
        statusMenu.removeAllItems()
        
        // Top menu items
        
        // use24HForLocalTZ
        statusItem = NSMenuItem(title: "Local time in 24H format", action:#selector(self.toggleUse24HForLocalTZ(_:)), keyEquivalent: "")
        
        if defaults.bool(forKey: use24HForLocalTZ) == true {
            statusItem.state = NSOnState
        } else {
            statusItem.state = NSOffState
        }
        
        statusMenu.addItem(statusItem)
        
        
        // displayDateForLocalTZ
        statusItem = NSMenuItem(title: "Display local date", action:#selector(self.toggleDisplayDateForLocalTZ(_:)), keyEquivalent: "")
        
        if defaults.bool(forKey: displayDateForLocalTZ) == true {
            statusItem.state = NSOnState
        } else {
            statusItem.state = NSOffState
        }
        
        statusMenu.addItem(statusItem)

        
        
        // Add all timezone items
        statusMenu.addItem(NSMenuItem.separator())
        
        for (index, tz) in timeZones.enumerated() {

            if tz.local == true {
                statusItem = NSMenuItem(title: tz.fancyname(), action: nil, keyEquivalent: "")
            } else {
                statusItem = NSMenuItem(title: tz.fancyname(), action:#selector(self.toggleVisibility(_:)), keyEquivalent: "")
            }
            
            if tz.local == false && tz.visible == true {
                statusItem.state = NSOnState
            } else {
                statusItem.state = NSOffState
            }
            
            statusItem.representedObject = timeZones[index]
            
            statusMenu.addItem(statusItem)
            
        }
        
        // Footer menu items
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(NSMenuItem(title: "Quit", action:#selector(NSApp.terminate(_:)), keyEquivalent: ""))
        
        mainStatusItem.menu = statusMenu
        
    }
    
    // Initializing timezones set via timezones list const
    func setTimeZones() {
        
        var addedTimezone: TRTimeZone
        
        for (_, tz) in STtimeZones.enumerated() {
            addedTimezone = TRTimeZone.init(name: tz, local: false, visible: true)
            
            timeZones.append(addedTimezone)
        }
    }
    
    
    func toggleVisibility(_ sender: NSMenuItem) {
        let tz: TRTimeZone = sender.representedObject as! TRTimeZone
        
        tz.visible = !tz.visible
    }
    
    func toggleDate() {
        STshowDate = !STshowDate
    }
    
    func toggleUse24HForLocalTZ(_ sender: NSMenuItem) {
        defaults.set(!defaults.bool(forKey: use24HForLocalTZ), forKey: use24HForLocalTZ)
    }
    
    func toggleDisplayDateForLocalTZ(_ sender: NSMenuItem) {
        defaults.set(!defaults.bool(forKey: displayDateForLocalTZ), forKey: displayDateForLocalTZ)
    }
    
    
    
    func setDefaults() {
        
        defaults.set(false, forKey: use24HForLocalTZ)
        defaults.set(true, forKey: displayDateForLocalTZ)
        
    }
    
}


class TRTimeZone {
    
    var name: String = ""
    
    var local: Bool = false
    var visible: Bool = false
    
    func offset() -> String {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: self.name)
        dateFormat.dateFormat = "Z"
        return dateFormat.string(from: Date())
    }
    
    func fancyname() -> String {
//        let fn = NSTimeZone(name: self.name)!.localizedName(.ShortGeneric, locale: NSLocale(localeIdentifier: "en-US"))
//        return fn!

        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: self.name)
        dateFormat.locale = Locale(identifier: "en-US")
        dateFormat.dateFormat = "vvvv, ZZZZ"
        return dateFormat.string(from: Date())
        
    }
    
    //        case Standard
    //        case ShortStandard
    //        case DaylightSaving
    //        case ShortDaylightSaving
    //        case Generic
    //        case ShortGeneric
    
    init (name: String, local: Bool, visible: Bool) {
        self.name = name
        self.local = local
        self.visible = visible
    }
    
}




