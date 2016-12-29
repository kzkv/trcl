//
//  AppDelegate.swift
//  trclLauncher
//
//  Created by Tyoma Kazakov on 16.11.2016.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        
        let mainAppIdentifier = "kzkv.trcl"
        let running           = NSWorkspace.shared().runningApplications
        var alreadyRunning    = false
        
        for app in running {
            if app.bundleIdentifier == mainAppIdentifier {
                alreadyRunning = true
                break
            }
        }
        
        if !alreadyRunning {
            
            DistributedNotificationCenter.default().addObserver(observer: AppDelegate, selector: "terminate", name: "killme", object: mainAppIdentifier)
            
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("MainApplication") //main app name
            let newPath = NSString.path(withComponents: components)
            
            NSWorkspace.shared().launchApplication(newPath)
        }
        else {
            self.terminate()
        }
    }
    
    func terminate() {
        NSApp.terminate(nil)
    }

        
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

