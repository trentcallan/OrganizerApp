//
//  TabBarController.swift
//  College
//
//  Created by Trent Callan on 6/6/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    @IBOutlet weak var TabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tab = TabBar.items {
            tab[3].title = "Goals"
        }
        // Do any additional setup after loading the view.
    }
    

}
