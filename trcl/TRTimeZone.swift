//
//  TRTimeZone.swift
//  trcl
//
//  Created by Tyoma Kazakov on 13.11.2016.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

import Foundation

class TRTimeZone {
    
    var name: String = ""
    
    var visible: Bool = false
    
    func offset() -> String {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: self.name)
        dateFormat.dateFormat = "Z"
        return dateFormat.string(from: Date())
    }
    
    func fancyName() -> String {
        //        let fn = NSTimeZone(name: self.name)!.localizedName(.ShortGeneric, locale: NSLocale(localeIdentifier: "en-US"))
        //        return fn!
        
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: self.name)
        dateFormat.locale = Locale(identifier: "en-US")
        dateFormat.dateFormat = "vvvv, ZZZZ"
        return dateFormat.string(from: Date())
        
    }
    
    func isLocal() -> Bool {
        
        let localTimeZone = TRTimeZone(name: TimeZone.autoupdatingCurrent.identifier, visible: false)
        
        if self.offset() == localTimeZone.offset() {
            return true
        }
        else {
            return false
        }
    }
    
    init (name: String, visible: Bool) {
        self.name = name
        self.visible = visible
    }
    
}
