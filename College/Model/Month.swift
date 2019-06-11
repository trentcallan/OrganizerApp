//
//  Month.swift
//  College
//
//  Created by Trent Callan on 6/7/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation

class Month: NSObject {
    
    var name: String
    var days: [String]
    var fullDays: [String]
    
    init(name: String, days: [String], fullDays: [String]) {
        self.name = name
        self.days = days
        self.fullDays = fullDays
    }
    
}
