//
//  GoalWithType.swift
//  College
//
//  Created by Trent Callan on 6/18/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation

class GoalWithType: NSObject {
    
    var goals: [GoalData]
    var goalType: String
    var section: Int
    
    init(goals: [GoalData], goalType: String, section: Int) {
        self.goals = goals
        self.goalType = goalType
        self.section = section
    }
    
    
}
