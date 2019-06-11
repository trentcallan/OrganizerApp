//
//  toDoCell.swift
//  CollegeOrganization
//
//  Created by Trent Callan on 10/23/17.
//  Copyright © 2017 Trent Callan. All rights reserved.
//

import UIKit

class toDoCell: UITableViewCell {

    @IBOutlet weak var horizontalStack: UIStackView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var toDoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let darkBlue = UIColor.init(red: 0.02, green: 0.4, blue: 0.553, alpha: 1)
        let lightBlue = UIColor.init(red: 0.2588, green: 0.478, blue: 0.631, alpha: 1)
        
        horizontalStack.alignment = .fill
        horizontalStack.distribution = .fill
        //horizontalStack.addBackground(color: lightBlue)
        
        priorityLabel.textAlignment = .left
        priorityLabel.backgroundColor = UIColor.clear
        
        toDoLabel.textAlignment = .center
        toDoLabel.backgroundColor = UIColor.clear
        toDoLabel.numberOfLines = 0
        
        let font = UIFont(name: "Georgia", size: 24)
        toDoLabel.font = font
        priorityLabel.font = font
    }


}
