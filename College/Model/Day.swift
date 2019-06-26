//
//  Day.swift
//  College
//
//  Created by Trent Callan on 6/25/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation

class Day: NSObject {
    
    var dateString: String
    var date: Date
    
    init(date: Date, dateString: String) {
        self.dateString = dateString
        self.date = date
    }
    
}
