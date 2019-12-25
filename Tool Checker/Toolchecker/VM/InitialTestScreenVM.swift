//
//  InitialTestScreenVM.swift
//  Toolchecker
//
//  Created by Aashna Narula on 23/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import Foundation

enum TestType {
    case singleTest
    case runAllTest
    case testResults
    case deviceInfo
    case checkIMEI
    case phoneCleaner
}

class InitialTestScreenVM {
    var array: [TestType] = []
    
    init() {
        self.array = [.singleTest,.runAllTest,.testResults,.deviceInfo,.checkIMEI,.phoneCleaner]
    }
}
