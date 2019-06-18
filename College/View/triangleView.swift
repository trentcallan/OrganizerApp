//
//  triangleView.swift
//  College
//
//  Created by Trent Callan on 6/17/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class triangleView: UIView {
// Draws a triangle
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: (rect.maxX / 2), y: rect.minY))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.closePath()
        context.setFillColor(UIColor.gray.cgColor)
        context.fillPath()
    }
}
