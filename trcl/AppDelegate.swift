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
    let APPNAME = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String


    
    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBAction func quitClicked(sender: NSMenuItem) {
    }
    
    
    let mainStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    var timer = NSTimer()
    
    // TODO: persistable settings

    let STtimeZones = ["America/Los_Angeles", "America/New_York", "Europe/Moscow"]
    
    // Russian timezone for lookup when user settings are to use 24H/military there
    var STrus24H = true
    let RUS_TZ = "Europe/Moscow"
    
    var STshowDate = true
    
    // Time zone array
    var timeZones = [TRTimeZone]()
    
    // Local timezone object 
    var localTimeZone = TRTimeZone(name: NSTimeZone.localTimeZone().name, local: true, visible: false)
    
    
    @IBAction func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        setTimeZones()
        buildMenu()
        
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func menuClicked(sender: NSMenuItem) {
        
        
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
        font = NSFont.systemFontOfSize(12)
//                        font = NSFont(name: name, size: pointSize) ?? systemFont
        let fontManager = NSFontManager.sharedFontManager()
        font = fontManager.convertFont(font, toHaveTrait: .SmallCapsFontMask)
        let ampmFontAttr = [ NSFontAttributeName: font ]
        
        let timeFontAttr = [ NSFontAttributeName: NSFont.menuBarFontOfSize(0) ]
//        let dateFontAttr = [ NSFontAttributeName: NSFont.menuBarFontOfSize(10) ]
        let notLocalFontAttr = [ NSForegroundColorAttributeName: NSColor.grayColor() ]
        
        
        for (index, tz) in timeZones.enumerate() {
            
            var timeArray: [String] = ["",""]
        
//            var timeAttrString = NSAttributedString(string: "", attributes: timeFontAttributes)

            if tz.visible == true {
                if tz.local == true {
                    timeArray = formatTime(tz.name, local: true)

                    ftz.appendAttributedString(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                    ftz.appendAttributedString(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
                    ftz.appendAttributedString(NSAttributedString(string: " ", attributes: ampmFontAttr))
                    ftz.appendAttributedString(NSAttributedString(string: getDate(), attributes: ampmFontAttr))
                    // TODO: отключаемая дата

                }
                else {
                    timeArray = formatTime(tz.name, local: false)
                    
                    let rangeStart = ftz.length
                    
                    ftz.appendAttributedString(NSAttributedString(string: timeArray[0], attributes: timeFontAttr))
                    ftz.appendAttributedString(NSAttributedString(string: timeArray[1], attributes: ampmFontAttr))
                    ftz.addAttributes(notLocalFontAttr, range: NSMakeRange(rangeStart, ftz.length-rangeStart))
                    
                }

                if index != timeZones.count {
                    ftz.appendAttributedString(NSAttributedString(string: " ", attributes: ampmFontAttr))
                }
            } else {
                nonvisibleCounter += 1
            }
            
        }
        
        if nonvisibleCounter == timeZones.endIndex {
            // Incrementing counter to avoid empty string
            ftz.appendAttributedString(NSAttributedString(string: "trcl", attributes: timeFontAttr))
        }
        
        mainStatusItem.attributedTitle = ftz
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
    
    func setLocal() {
        
        localTimeZone.name = NSTimeZone.localTimeZone().name
        
        for (_,tz) in timeZones.enumerate() {
            tz.local = false
            
            if tz.offset() == localTimeZone.offset() {
                tz.local = true
            }
        }
        
        
        
//        print(timeZones[0...timeZones.endIndex].local)
        
        
        
    }
    
    
    func getDate() -> String { //    TODO: вообще-то это нет смысла вычислять два раза за секунду
        let usDateFormat = NSDateFormatter()
        usDateFormat.dateFormat = "MMM d"
        usDateFormat.locale = NSLocale(localeIdentifier: "en-US")
        return usDateFormat.stringFromDate(NSDate())
    }
    
    
    //TODO: call buildMenu only on user action (click on mainStatusItem)
    func buildMenu() {
        
        var statusItem = NSMenuItem()
        
        statusMenu.removeAllItems()
        
        
        // Add all timezone items
        for (index, tz) in timeZones.enumerate() {

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
        
        // Static menu items
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItem(NSMenuItem(title: "Quit", action:#selector(NSApp.terminate(_:)), keyEquivalent: ""))
        
        mainStatusItem.menu = statusMenu
        
    }
    
    // Initializing timezones set via timezones list const
    func setTimeZones() {
        
        var addedTimezone: TRTimeZone
        
        for (_, tz) in STtimeZones.enumerate() {
            addedTimezone = TRTimeZone.init(name: tz, local: false, visible: true)
            
            timeZones.append(addedTimezone)
        }
    }
    
    
    func toggleVisibility(sender: NSMenuItem) {
        let tz: TRTimeZone = sender.representedObject as! TRTimeZone
        
        tz.visible = !tz.visible
    }
    
    func toggleDate() {
        STshowDate = !STshowDate
    }
    
    func toggle24H() {
        STrus24H = !STrus24H
    }
    
}


class TRTimeZone {
    
    var name: String = ""
    
    var local: Bool = false
    var visible: Bool = false
    
    func offset() -> String {
        let dateFormat = NSDateFormatter()
        dateFormat.timeZone = NSTimeZone(name: self.name)
        dateFormat.dateFormat = "Z"
        return dateFormat.stringFromDate(NSDate())
    }
    
    func fancyname() -> String {
//        let fn = NSTimeZone(name: self.name)!.localizedName(.ShortGeneric, locale: NSLocale(localeIdentifier: "en-US"))
//        return fn!

        let dateFormat = NSDateFormatter()
        dateFormat.timeZone = NSTimeZone(name: self.name)
        dateFormat.locale = NSLocale(localeIdentifier: "en-US")
        dateFormat.dateFormat = "vvvv, ZZZZ"
        return dateFormat.stringFromDate(NSDate())
        
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



