//
//  GoalTypeChoiceView.swift
//  College
//
//  Created by Trent Callan on 6/17/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

protocol GoalTypeViewProtocol {
    func buttonTapped(goalType: String)
}

class GoalTypeChoiceView: UIView {

    let dailyButton = UIButton()
    let weeklyButton = UIButton()
    let monthlyButton = UIButton()
    let yearlyButton = UIButton()
    var delegate: GoalTypeViewProtocol? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dailyButton.frame = CGRect(x: 0, y: 0, width: 160, height: 40)
        weeklyButton.frame = CGRect(x: 0, y: 40, width: 160, height: 40)
        monthlyButton.frame = CGRect(x: 0, y: 80, width: 160, height: 40)
        yearlyButton.frame = CGRect(x: 0, y: 120, width: 160, height: 40)
        
        dailyButton.setTitle("Daily Goal", for: .normal)
        weeklyButton.setTitle("Weekly Goal", for: .normal)
        monthlyButton.setTitle("Monthly Goal", for: .normal)
        yearlyButton.setTitle("Yearly Goal", for: .normal)
        
        dailyButton.setTitleColor(UIColor.blue, for: .highlighted)
        weeklyButton.setTitleColor(UIColor.blue, for: .highlighted)
        monthlyButton.setTitleColor(UIColor.blue, for: .highlighted)
        yearlyButton.setTitleColor(UIColor.blue, for: .highlighted)

        dailyButton.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
        weeklyButton.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
        monthlyButton.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
        yearlyButton.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
        
        self.addSubview(dailyButton)
        self.addSubview(weeklyButton)
        self.addSubview(monthlyButton)
        self.addSubview(yearlyButton)
        
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTouch(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            switch title {
                case "Daily Goal":
                    delegate?.buttonTapped(goalType: "Daily")
                case "Weekly Goal":
                    delegate?.buttonTapped(goalType: "Weekly")
                case "Monthly Goal":
                    delegate?.buttonTapped(goalType: "Monthly")
                case "Yearly Goal":
                    delegate?.buttonTapped(goalType: "Yearly")
                default:
                    print("error")
            }
        }
    }


}
