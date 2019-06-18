//
//  GoalViewCell.swift
//  College
//
//  Created by Trent Callan on 10/24/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit
import Charts

class GoalViewCell: UICollectionViewCell {
    
    @IBOutlet weak var goalDescription: UILabel!
    @IBOutlet weak var goalType: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goalDescription.numberOfLines = 0
        goalType.adjustsFontSizeToFitWidth = true
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.noDataText = "No data to display"
        pieChart.isUserInteractionEnabled = false
        
        pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        pieChart.backgroundColor = UIColor.lightGray
        pieChart.holeRadiusPercent = 0.5
        pieChart.chartDescription?.text = ""
        pieChart.centerText = ""
        
        /*goalType.layer.borderColor = UIColor.black.cgColor
        goalType.layer.borderWidth = 1.0
        goalDescription.layer.borderColor = UIColor.black.cgColor
        goalDescription.layer.borderWidth = 1.0
        pieChart.layer.borderColor = UIColor.black.cgColor
        pieChart.layer.borderWidth = 1.0
        pieChart.layer.shadowOffset = CGSize(width: -1.5, height: 1.5)
        pieChart.layer.shadowOpacity = 1.0
        pieChart.layer.shadowRadius = 3.0*/
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        //self.layer.shadowOffset = CGSize(width: -1.5, height: 1.5)
        //self.layer.shadowOpacity = 1.0
        //self.layer.shadowRadius = 3.0
        self.layer.cornerRadius = 3.0
        
        
    }
    
    func setUpPieChart(chartData: PieChartData) {
        pieChart.data = chartData
    }
    
    
}
