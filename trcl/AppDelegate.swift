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

    let STtimeZones = ["America/Los_Angeles", "America/New_York", "Europe/Moscow"]
    
    // Russian timezone for lookup when user settings are to use 24H/military there
    var STrus24H = true
    let RUS_TZ = "Europe/Moscow"
    
    var STshowDate = true
    
    // Time zone array
    var timeZones = [TRTimeZone]()
    
    // Local timezone object 
    var localTimeZone = TRTimeZone(name: TimeZone.autoupdatingCurrent.identifier, local: true, visible: false)
    
    
    @IBAction func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        setTimeZones()
        buildMenu()
        
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
        font = NSFont.systemFont(ofSize: 12)
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
                    ftz.append(NSAttributedString(string: getDate(), attributes: ampmFontAttr))
                    // TODO: отключаемая дата

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
        
        
        
//        print(timeZones[0...timeZones.endIndex].local)
        
        
        
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
        
        
        // Add all timezone items
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
        
        // Static menu items
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
    
    func toggle24H() {
        STrus24H = !STrus24H
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



