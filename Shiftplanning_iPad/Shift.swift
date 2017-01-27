//
//  Shift.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import Foundation

class Shift {
    var id : Int
    var start : Date
    var end : Date
    var employees : [Employee]
    var checkIns : [CheckIn]
    
    init(id:Int, start:Date, end:Date, employees:[Employee], checkIns:[CheckIn]) {
        self.id = id
        self.start = start
        self.end = end
        self.employees = employees
        self.checkIns = checkIns
    }
}
