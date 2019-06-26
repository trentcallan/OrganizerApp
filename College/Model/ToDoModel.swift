//
//  ToDoModel.swift
//  College
//
//  Created by Trent Callan on 6/11/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation

class ToDoModel: NSObject {
    
    var ID: String
    var toDo: String
    var priority: String
    
    init(ID: String, toDo: String, priority: String) {
        self.ID = ID
        self.toDo = toDo
        self.priority = priority
    }
    
}
