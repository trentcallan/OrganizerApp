//
//  GroceryItem.swift
//  CollegeOrganization
//
//  Created by Trent Callan on 10/11/17.
//  Copyright © 2017 Trent Callan. All rights reserved.
//

import UIKit

class GroceryItem: NSObject {
    
    var category: String
    var items: [String]
    var quantities: [String]
    
    init(items: [String], category: String, quantities: [String]) {
        self.items = items
        self.category = category
        self.quantities = quantities
    }
    
    func addItemWithQuantity(item: String, quantity: String) {
        self.items.append(item)
        self.quantities.append(quantity)
    }
    
}
