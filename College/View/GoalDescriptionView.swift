//
//  GoalDescriptionView.swift
//  College
//
//  Created by Trent Callan on 6/18/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

protocol GoalDescriptionViewProtocol {
    func doneButtonTapped(goalDescription: String, goalType: String)
    func cancelButtonTapped()
}

class GoalDescriptionView: UIView {

    var goalTypeLabel = UILabel()
    var goalDescriptionTextField = UITextField()
    var doneButton = UIButton()
    var cancelButton = UIButton()
    var delegate: GoalDescriptionViewProtocol? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray
        self.layer.cornerRadius = 4
        
        goalTypeLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 2 * (self.bounds.size.height / 5))
        goalTypeLabel.textAlignment = .center
        
        goalDescriptionTextField.frame = CGRect(x: 8, y: 2 * (self.bounds.size.height / 5), width: self.bounds.size.width-16, height: (1 * (self.bounds.size.height / 5)))
        goalDescriptionTextField.allowsEditingTextAttributes = true
        goalDescriptionTextField.placeholder = "Goal Description"
        goalDescriptionTextField.backgroundColor = UIColor.white
        goalDescriptionTextField.layer.cornerRadius = 8
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.blue, for: .highlighted)
        doneButton.frame = CGRect(x: 0, y: (3 * (self.bounds.size.height / 5)), width: self.frame.size.width/2, height: 2*(self.bounds.size.height / 5))
        doneButton.addTarget(self, action: #selector(handleDoneTap), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.blue, for: .highlighted)
        cancelButton.frame = CGRect(x: self.frame.size.width/2, y: (3 * (self.bounds.size.height / 5)), width: self.frame.size.width/2, height: 2*(self.bounds.size.height / 5))
        cancelButton.addTarget(self, action: #selector(handleCancelTap), for: .touchUpInside)
        
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        self.addSubview(goalTypeLabel)
        self.addSubview(goalDescriptionTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleDoneTap() {
        if let goalDescString = goalDescriptionTextField.text, let goalTypeString = goalTypeLabel.text {
            delegate?.doneButtonTapped(goalDescription: goalDescString, goalType: goalTypeString)
        }
    }
    
    @objc func handleCancelTap() {
        delegate?.cancelButtonTapped()
    }
}
