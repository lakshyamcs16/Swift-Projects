//
//  GridView.swift
//  Toolchecker
//
//  Created by Aashna Narula on 27/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    var numberOfColumns: Int = 8
    var numberOfRows: Int = 12
    var lineWidth: CGFloat = 1.0
    var lineColor: UIColor = UIColor.gray
    var columnWidth: Int = 0
    var rowHeight: Int = 0
    var allLayersTouched: [[Bool]] = [[]]
    var touchVC = TouchViewController.newInstance()
    
    func goToTestView() {
        let controller = touchVC.navigationController?.viewControllers[(touchVC.navigationController?.viewControllers.count)! - 3]
        touchVC.navigationController?.popToViewController(controller!, animated: true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let touchpoint:CGPoint = touch.location(in: self)
        let xInt = Int(touchpoint.x)
        let yInt = Int(touchpoint.y)
        let x = Int(Int(touchpoint.x) - (xInt % columnWidth))
        let y = Int(Int(touchpoint.y) -  (yInt % rowHeight))
        //print("\(x) : \(y) / \(touchpoint.x) : \(touchpoint.y)")
        var w = columnWidth
        var h = rowHeight
        if((x + 2*columnWidth) > Int(frame.size.width)) {
            w = 2*w
        }
        if((y + 2*rowHeight) > Int(frame.size.height)) {
            h = 2*h
        }
        
        let someFrame = CGRect(x: x, y: y, width: w, height: h)
        let isPointInFrame = someFrame.contains(touchpoint)
        let pointColor = colorOfPoint(point: touchpoint)
        if isPointInFrame && !pointColor.isEqual(UIColor.red){
            let levelLayer = CAShapeLayer()
            levelLayer.path = UIBezierPath(roundedRect: someFrame,
                                           cornerRadius: 0).cgPath
            let xC = xInt / columnWidth
            let yC = yInt / rowHeight
            
            if xC <= numberOfColumns && yC <= numberOfRows {
                allLayersTouched[yC][xC] = true
            }
            
            levelLayer.fillColor = UIColor.red.cgColor
            self.layer.addSublayer(levelLayer)
        }
        
        if checkIfComplete(layers: allLayersTouched){
            let alert = UIAlertController(title: "Touch Check", message: "Touch test passed", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.goToTestView()
                print("Passed")
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.goToTestView()
                print("Failed")
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            //touchVC.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkIfComplete(layers: [[Bool]]) -> Bool {
        for i in layers {
            for j in i {
                if j == false {
                    return false
                }
            }
        }
        
        return true
    }
    override func draw(_ rect: CGRect) {
        allLayersTouched = Array(repeating: Array(repeating: false, count: 9), count: 13)
        if let context = UIGraphicsGetCurrentContext() {
            
            context.setLineWidth(lineWidth)
            context.setStrokeColor(UIColor.gray.cgColor)
            
            self.columnWidth = Int(rect.width) / (numberOfColumns + 1)
            for i in 1...numberOfColumns {
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = CGFloat(columnWidth * i)
                startPoint.y = 0.0
                endPoint.x = startPoint.x
                endPoint.y = frame.size.height
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }
            
            self.rowHeight = Int(rect.height) / (numberOfRows + 1)
            for j in 1...numberOfRows {
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = 0.0
                startPoint.y = CGFloat(rowHeight * j)
                endPoint.x = frame.size.width
                endPoint.y = startPoint.y
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }
        }
    }
}

extension UIView {
    func colorOfPoint(point: CGPoint) -> UIColor {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        self.layer.render(in: context!)
        
        let red: CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green: CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue: CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha: CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
}
