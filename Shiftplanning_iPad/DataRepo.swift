//
//  DataRepo.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import Foundation

class DataRepo {
    class var sharedInstance: DataRepo {
        struct Singleton {
            static let instance = DataRepo()
        }
        return Singleton.instance
    }
    
    var tShifts:[Shift] = []
    var employees:[Employee] = []
    
    func flush() {
        tShifts = []
        employees = []
    }
}
