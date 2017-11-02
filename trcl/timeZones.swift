//
//  timeZones.swift
//  trcl
//
//  Created by Tyoma Kazakov on 13.11.2016.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

import Foundation


let STtimeZones = [
    "Pacific/Niue",         //-1100
    
    "Pacific/Honolulu",     //-1000
    
    "Pacific/Marquesas",    // -930
    
    "America/Anchorage",    // -900
    
    "America/Los_Angeles",  // -800
    "America/Dawson",       // -800
    
    "America/Edmonton",     // -700
    "America/Phoenix",      // -700
    
    "America/Winnipeg",     // -600
    "America/Chicago",      // -600
    "America/Mexico_City",  // -600
    "America/Guatemala",    // -600
    
    "America/Toronto",      // -500
    "America/New_York",     // -500
    "America/Havana",       // -500
    "America/Lima",         // -500
    
    "America/Caracas",      // -400
    "America/Santiago",     // -400
    
    "America/Sao_Paulo",    // -300
    "America/Argentina/Buenos_Aires",
                            // -300
    
    "Atlantic/Cape_Verde",  // -100
    
    "Europe/London",            //0
    "Europe/Berlin",            //1
    "Asia/Jerusalem",           //2 Possibly not a principle city
    "Europe/Moscow",            //3 No daylight saving
    "Asia/Dubai",               //4
    "Asia/Yekaterinburg",       //5 Possibly not a principle city
    "Asia/Omsk",                //6
    "Asia/Jakarta",             //7 Possibly not a principle city
    "Asia/Singapore",           //8 Didn't find Beijing on the list
    "Asia/Tokyo",               //9
    "Australia/Sydney",         //10
    //"Pacific/Noumea",         //11 Possibly not a principle city
    "Pacific/Fiji"              //12
]

class TimeZoneDescriptor {
    
    var key: String = ""
    
    var fancyName: String = ""
    var zulu: Int = 0
    var gmtOffset: String = ""
    
    var isDST: Bool = false
    
    init (key: String) {
        self.key = key
        
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: key)
        dateFormat.locale = Locale(identifier: "en-US")
        
        dateFormat.dateFormat = "vvvv"
        self.fancyName = dateFormat.string(from: Date())
        
        dateFormat.dateFormat = "Z"
        self.zulu = Int(dateFormat.string(from: Date()))!
        
        dateFormat.dateFormat = "ZZZZ"
        self.gmtOffset = dateFormat.string(from: Date())
        
        self.isDST = (TimeZone(identifier: key)?.isDaylightSavingTime())!
    }
    
}


func tzResearch() {
    let tzlist = TimeZone.knownTimeZoneIdentifiers
    
    var timezones = [TimeZoneDescriptor]()
    
//    print(tzlist)
    
    for (_, tz) in tzlist.enumerated() {
        //TODO: what if this runs slowly and some very unfortunate person starts tz initialization right on midnight, GMT?

        let key: String
        
        key = tz
        
        let timeZoneDescriptor = TimeZoneDescriptor.init(key: key)
        timezones.append(timeZoneDescriptor)
        
        
//
//
//        let zulu = DateFormatter()
//        zulu.timeZone = TimeZone(identifier: tz)
//        zulu.dateFormat = "Z"
//
//        let dateFormat = DateFormatter()
//        dateFormat.timeZone = TimeZone(identifier: tz)
//        dateFormat.locale = Locale(identifier: "en-US")
//        dateFormat.dateFormat = "vvvv, ZZZZ"
//
//        let tzi = TimeZone(identifier: tz)
//        let isDST = tzi?.isDaylightSavingTime()
//
//        let offset:Int?
//        offset = Int(zulu.string(from: Date()))
//
        
//        print(tz + " " + offset + " " + dateFormat.string(from: Date()) + " " + (isDST?.description)!)

//        print(String(offset) + " " + dateFormat.string(from: Date()))
    }
    
    
    timezones.sort(by: {$0.zulu < $1.zulu} )
    
    dump(timezones)

}
