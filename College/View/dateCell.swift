//
//  dateCell.swift
//  College
//
//  Created by Trent Callan on 11/1/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit

class dateCell: UICollectionViewCell {
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.date.textAlignment = .center
        
    }
}
