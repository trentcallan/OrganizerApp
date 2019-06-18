//
//  Recipe.swift
//  Project 10
//
//  Created by Trent Callan on 10/8/17.
//  Copyright © 2017 Trent Callan. All rights reserved.
//

import UIKit

class Recipe: NSObject {

    var title: String
    var ingredients: [String]
    var amount : [String]
    var ingredientAndAmountDictionary: [String : Int]
    
    init(title: String, ingredients: [String], amount: [String]) {
        self.title = title
        self.ingredients = ingredients
        self.amount = amount
        self.ingredientAndAmountDictionary = [:]
    }



}


