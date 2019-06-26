//
//  Extensions.swift
//  College
//
//  Created by Trent Callan on 6/7/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var fullDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    var fullDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:MM:SS"
        return dateFormatter.date(from: self)
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

extension String {
    var goalTypeSection: Int {
        var numToReturn: Int
        switch self {
        case "Daily":
            numToReturn = 0
        case "Weekly":
            numToReturn = 1
        case "Monthly":
            numToReturn = 2
        case "Yearly":
            numToReturn = 3
        default:
            numToReturn = 0
        }
        return numToReturn
    }
    
}
