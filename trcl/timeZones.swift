//
//  timeZones.swift
//  trcl
//
//  Created by Tyoma Kazakov on 13.11.2016.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

import Foundation


let STtimeZones = [
    //"America/Nome",           //-11 Possibly not a principle city
    "Pacific/Honolulu",         //-10
    "America/Anchorage",        //-9
    "America/Los_Angeles",      //-8
    "America/Phoenix",          //-7
    "America/Chicago",          //-6
    "America/New_York",         //-5
    "America/Santiago",         //-4
    "America/Sao_Paulo",        //-3
    //"America/Noronha",        //-2 Possibly not a principle city
    "Atlantic/Cape_Verde",      //-1
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

func tzResearch() {
    let tzlist = TimeZone.knownTimeZoneIdentifiers
    
//    print(tzlist)
    
    for (_, tz) in tzlist.enumerated() {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: tz)
        dateFormat.dateFormat = "Z"
        
        print(tz + ", " + dateFormat.string(from: Date()))
    }
}
