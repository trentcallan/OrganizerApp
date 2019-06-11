//
//  Calendar.swift
//  College
//
//  Created by Trent Callan on 6/6/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation
import UIKit

class CalendarModel: NSObject {
    
    var date: Date
    var dateString: String
    var dates: [String]
    var months: [Month]
    
    init(date: Date) {
        self.date = date
        let format = DateFormatter()
        format.dateFormat = "MMM dd, yyyy"
        let dateFormatted = format.string(from: date)
        self.dateString = dateFormatted
        self.dates = []
        self.months = []
    }
    
    func getArrayOfDateStrings() -> [String] {
        var daysStringArray: [String] = []
        var startDate = date
        let currentDate = Date()
        let format = DateFormatter()
        format.dateFormat = "MMM dd, yyyy"
        var tempMonths = [Month]()
        var days = [String]()
        var fullDays = [String]()
        var currentMonth = startDate.month
        
        while startDate.compare(currentDate) == .orderedAscending {
            let currentDay = Calendar.current.isDate(currentDate, inSameDayAs: startDate)
            if(startDate.month != currentMonth || currentDay) {
                if(currentDay) {
                    days.append(startDate.day)
                    fullDays.append(startDate.fullDay)
                }
                tempMonths.append(Month(name: currentMonth, days: days, fullDays: fullDays))
                currentMonth = startDate.month
                days.removeAll()
                fullDays.removeAll()
            }
            days.append(startDate.day)
            fullDays.append(startDate.fullDay)
            let dateFormatted = format.string(from: startDate)
            daysStringArray.append(dateFormatted)
            if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) {
                startDate = nextDate
            }
        }
        self.months = tempMonths
        return daysStringArray
    }
    
}
