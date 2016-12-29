//
//  GlobalVariables.swift
//  trcl
//
//  Created by Tyoma Kazakov on 16.11.2016.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

import Foundation

let defaults = UserDefaults.standard

// Defaults namestring constants
let use24HForLocalTZ = "use24HForLocalTZ"
let displayDateForLocalTZ = "displayDateForLocalTZ"
let autostart = "autostart"

// Time zone objects array
var timeZones = [TRTimeZone]()

// Current date for the main string
var currentDateString = String()


// Setting current date on calendar change 
func getDate() -> String {
    let usDateFormat = DateFormatter()
    usDateFormat.dateFormat = "MMM d"
    usDateFormat.locale = Locale(identifier: "en-US")
    return usDateFormat.string(from: Date())
}

func calendarDayDidChange(notification: Notification) -> Void {
    currentDateString = getDate()
}
