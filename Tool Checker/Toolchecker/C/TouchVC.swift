//
//  TouchVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 27/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class TouchVC: UIView {

        private var path = UIBezierPath()
        class func newInstance() -> UIView {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "touchVC") as? TouchVC else {
                return UIView()
            }
            return vc
        }
        fileprivate var gridWidthMultiple: CGFloat
        {
            return 10
        }
        fileprivate var gridHeightMultiple : CGFloat
        {
            return 20
        }
        
        fileprivate var gridWidth: CGFloat
        {
            return bounds.width/CGFloat(gridWidthMultiple)
        }
        
        fileprivate var gridHeight: CGFloat
        {
            return bounds.height/CGFloat(gridHeightMultiple)
        }
        
        fileprivate var gridCenter: CGPoint {
            return CGPoint(x: bounds.midX, y: bounds.midY)
        }
        
        fileprivate func drawGrid()
        {
            path = UIBezierPath()
            path.lineWidth = 5.0
            
            for index in 1...Int(gridWidthMultiple) - 1
            {
                let start = CGPoint(x: CGFloat(index) * gridWidth, y: 0)
                let end = CGPoint(x: CGFloat(index) * gridWidth, y:bounds.height)
                path.move(to: start)
                path.addLine(to: end)
            }
            //Close the path.
            path.close()
            
        }
        
        override func draw(_ rect: CGRect)
        {
            drawGrid()
            
            // Specify a border (stroke) color.
            UIColor.purple.setStroke()
            path.stroke()
        }
}
