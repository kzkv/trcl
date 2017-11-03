//
//  MainMenu.swift
//  trcl
//
//  Created by Tyoma Kazakov on 30.12.2016.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

import Cocoa

class MainMenuDelegate: NSObject, NSMenuDelegate {
    
//    lazy var appDelegate = NSApplication.shared().delegate as! AppDelegate

    
    // TODO: cut out the menu filler after the functionality was replicated
    
//    func menuNeedsUpdate(_ menu: NSMenu) {
//
////        if (menu != appDelegate.mainMenu) {
////            return
////        }
//
//        var statusItem = NSMenuItem()
//
//        menu.removeAllItems()
//
//        // Top menu items
//
//        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
//        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
//        let versionString = "Ternary clock (trcl) by Tom Kazakov, v" + version + "(" + build + ")"
//        statusItem = NSMenuItem(title: versionString, action: nil, keyEquivalent: "")
//        menu.addItem(statusItem)
//        menu.addItem(NSMenuItem.separator())
//
//
//        // use24HForLocalTZ
//        statusItem = NSMenuItem(title: "Local time in 24H format", action:#selector(self.toggleUse24HForLocalTZ(_:)), keyEquivalent: "")
//
//        if defaults.bool(forKey: use24HForLocalTZ) == true {
//            statusItem.state = NSOnState
//        } else {
//            statusItem.state = NSOffState
//        }
//
//        statusItem.target = self;
//        menu.addItem(statusItem)
//
//
//        // displayDateForLocalTZ
//        statusItem = NSMenuItem(title: "Display local date", action:#selector(self.toggleDisplayDateForLocalTZ(_:)), keyEquivalent: "")
//
//        if defaults.bool(forKey: displayDateForLocalTZ) == true {
//            statusItem.state = NSOnState
//        } else {
//            statusItem.state = NSOffState
//        }
//
//        statusItem.target = self;
//        menu.addItem(statusItem)
//
//
//
//        // Add all timezone items
//        menu.addItem(NSMenuItem.separator())
//
//        for (index, tz) in timeZones.enumerated() {
//
//            if tz.isLocal() == true {
//                statusItem = NSMenuItem(title: tz.fancyName(), action: nil, keyEquivalent: "")
//
//                // Settings on visibility state for the local timezone
//                defaults.set(false, forKey: tz.name+"Visible")
//
//            } else {
//                statusItem = NSMenuItem(title: tz.fancyName(), action:#selector(self.toggleVisibility(_:)), keyEquivalent: "")
//            }
//
//            if tz.isLocal() == false && defaults.bool(forKey: tz.name+"Visible") == true {
//                statusItem.state = NSOnState
//            } else {
//                statusItem.state = NSOffState
//            }
//
//            statusItem.representedObject = timeZones[index]
//
//            statusItem.target = self;
//            menu.addItem(statusItem)
//
//        }
//        
//        // Footer menu items
//        menu.addItem(NSMenuItem.separator())
//
//        // autostart
//        //        statusItem = NSMenuItem(title: "Autostart trcl", action:#selector(self.toggleAutostart(_:)), keyEquivalent: "")
//        //        if defaults.bool(forKey: autostart) == true {
//        //            statusItem.state = NSOnState
//        //        } else {
//        //            statusItem.state = NSOffState
//        //        }
//        //        statusMenu.addItem(statusItem)
//        //        statusMenu.addItem(NSMenuItem.separator())
//
//        menu.addItem(NSMenuItem(title: "Quit", action:#selector(NSApp.terminate(_:)), keyEquivalent: ""))
//
//    }
//    func toggleVisibility(_ sender: NSMenuItem) {
//        let tz: TRTimeZone = sender.representedObject as! TRTimeZone
//
//        defaults.set(!defaults.bool(forKey: tz.name+"Visible"), forKey: tz.name+"Visible")
//    }
//
//
//    func toggleUse24HForLocalTZ(_ sender: NSMenuItem) {
//        defaults.set(!defaults.bool(forKey: use24HForLocalTZ), forKey: use24HForLocalTZ)
//    }
//
//
//    func toggleDisplayDateForLocalTZ(_ sender: NSMenuItem) {
//        defaults.set(!defaults.bool(forKey: displayDateForLocalTZ), forKey: displayDateForLocalTZ)
//    }
//
//    @IBAction func quitClicked(_ sender: NSMenuItem) {
//    }

    
}
