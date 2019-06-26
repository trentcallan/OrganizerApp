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
    var days: [Day]
    
    init(name: String) {
        self.name = name
        self.days = []
    }
    
    func addDay(day: Day) {
        days.append(day)
    }
    
}
