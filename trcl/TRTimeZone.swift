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
    
    func offset() -> String {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: self.name)
        dateFormat.dateFormat = "Z"
        return dateFormat.string(from: Date())
    }
    
    func fancyName() -> String {
        let dateFormat = DateFormatter()

        dateFormat.timeZone = TimeZone(identifier: self.name)
        dateFormat.locale = Locale(identifier: "en-US")
        dateFormat.dateFormat = "vvvv, ZZZZ"
        return dateFormat.string(from: Date())
    }
    
    func isLocal() -> Bool {
        let localTimeZone = TRTimeZone(name: TimeZone.autoupdatingCurrent.identifier)
        
        if self.offset() == localTimeZone.offset() {
            return true
        }
        else {
            return false
        }
    }
    
    init (name: String) {
        self.name = name
    }
    
}
