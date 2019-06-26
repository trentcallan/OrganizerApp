//
//  GoalHeaderReusableView.swift
//  College
//
//  Created by Trent Callan on 6/18/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class GoalHeaderReusableView: UICollectionReusableView {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.label.font = UIFont.systemFont(ofSize: 32)
        self.label.textAlignment = .center
        self.label.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
