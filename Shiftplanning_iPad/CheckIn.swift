//
//  CheckIn.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import Foundation

class CheckIn {
    var id : Int
    var time : Date
    var employee : Employee
    
    init(id:Int, time:Date, employee:Employee) {
        self.id = id
        self.time = time
        self.employee = employee
    }
}
