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
    var countOfDays: Int = 0
    
    init(date: Date) {
        self.date = date
        let format = DateFormatter()
        format.dateFormat = "MMM dd, yyyy"
        let dateFormatted = format.string(from: date)
        self.dateString = dateFormatted
        self.dates = []
        self.months = []
        
        super.init()
        let currentDate = Date()
        addDaysAndMonths(startDate: date, currentDate: currentDate)

    }
    
    func addDaysAndMonths(startDate: Date, currentDate: Date) {
        let calendar = Calendar(identifier: .gregorian)
        let dayComponents = calendar.dateComponents(Set([.day]), from: startDate, to: currentDate)
        let monthComponents = calendar.dateComponents(Set([.month]), from: startDate, to: currentDate)

        for i in 0 ... monthComponents.month! {
            guard let monthDate = calendar.date(byAdding: .month, value: i, to: startDate) else {
                continue
            }
            let month = Month(name: monthDate.month)
            months.append(month)
            
            var numOfDays = dayComponents.day ?? 0
            if(numOfDays != 0) {
                numOfDays += 1
            }
            for j in 0 ... numOfDays {
                guard let date = calendar.date(byAdding: .day, value: j, to: startDate) else {
                    continue
                }
                let day = Day(date: date, dateString: date.day)
                months[i].addDay(day: day)
                countOfDays += 1
            }
        }

    }
    
}
