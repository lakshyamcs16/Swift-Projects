//
//  ViewController.swift
//  ScrollView
//
//  Created by Aashna Narula on 11/02/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLabel1()
        self.setLabel3()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func playButtonTapped(_ sender: Any) {
        
    }
    
    
    func setLabel1() {
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        
        let beginningAttributedString = NSAttributedString(string: "The goal of the game ", attributes: regularAttribute )
        let endAttributedString1 = NSAttributedString(string: " is to observe and categorise shapes based on their appearance and color. \n\nThe following are the", attributes: regularAttribute )
        let endAttributedString2 = NSAttributedString(string: " for the game.\nYou have to match the shape occuring on the upper right side of the playground with all the shapes occuring in the deck. \n Let's get you familiar with some ", attributes: regularAttribute )
        let endAttributedString3 = NSAttributedString(string: "that you are going to see on your playground. ", attributes: regularAttribute )
        
        
        let attrString1 =  NSAttributedString(string: "Let's Shapify ", attributes: boldAttribute)
        let attrString2 =  NSAttributedString(string: " rules ", attributes: boldAttribute)
        let attrString3 =  NSAttributedString(string: "Shapes ", attributes: boldAttribute)
        
        let fullString =  NSMutableAttributedString()
        fullString.append(beginningAttributedString)
        fullString.append(attrString1)
        fullString.append(endAttributedString1)
        fullString.append(attrString2)
        fullString.append(endAttributedString2)
        fullString.append(attrString3)
        fullString.append(endAttributedString3)
        
        label1.attributedText = fullString
        label1.font = UIFont(name: "Chalkboard SE", size: 17.0)
    }
    
    func setLabel3() {
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        
        let beginningAttributedString = NSAttributedString(string: "• Level 1 - Level 15:  Time - ", attributes: regularAttribute )
        let endAttributedString1 = NSAttributedString(string: "\n\n• Level 16 - Level 35 :  Time - ", attributes: regularAttribute )
        let endAttributedString2 = NSAttributedString(string: "\n\n• Level 36 - Level 45 :  Time - ", attributes: regularAttribute )
        let endAttributedString3 = NSAttributedString(string: "\n\n• Level 46 - Level 65 :  Time - ", attributes: regularAttribute )
        let endAttributedString4 = NSAttributedString(string: "\n\n• Level 66 - Level 85 :  Time - ", attributes: regularAttribute )
        let endAttributedString5 = NSAttributedString(string: "\n\n• Level 86 - Level 105 :  Time - ", attributes: regularAttribute )
        let endAttributedString6 = NSAttributedString(string: "\n\n• Level 106 - Level 120 :  Time - ", attributes: regularAttribute )
        
        
        let attrString1 =  NSAttributedString(string: "7 Seconds", attributes: boldAttribute)
        let attrString2 =  NSAttributedString(string: "10 Seconds", attributes: boldAttribute)
        let attrString3 =  NSAttributedString(string: "12 Seconds ", attributes: boldAttribute)
        let attrString4 =  NSAttributedString(string: "15 Seconds ", attributes: boldAttribute)
        let attrString5 =  NSAttributedString(string: "17 Seconds ", attributes: boldAttribute)
        let attrString6 =  NSAttributedString(string: "20 Seconds ", attributes: boldAttribute)
        let attrString7 =  NSAttributedString(string: "22 Seconds ", attributes: boldAttribute)
        
        let fullString =  NSMutableAttributedString()
        fullString.append(beginningAttributedString)
        fullString.append(attrString1)
        fullString.append(endAttributedString1)
        fullString.append(attrString2)
        fullString.append(endAttributedString2)
        fullString.append(attrString3)
        fullString.append(endAttributedString3)
        fullString.append(attrString4)
        fullString.append(endAttributedString4)
        fullString.append(attrString5)
        fullString.append(endAttributedString5)
        fullString.append(attrString6)
        fullString.append(endAttributedString6)
        fullString.append(attrString7)
        
        label3.attributedText = fullString
        label3.font = UIFont(name: "Chalkboard SE", size: 17.0)
    }
}

