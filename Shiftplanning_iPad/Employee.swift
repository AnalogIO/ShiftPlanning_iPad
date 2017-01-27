//
//  Employee.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import Foundation

class Employee {
    var id : Int
    var employeeTitle : String
    var employeeTitleId : Int
    var firstName : String
    var lastName : String
    var completed : Bool
    
    init(id:Int, employeeTitle:String, employeeTitleId:Int, firstName:String, lastName:String) {
        self.id = id
        self.employeeTitle = employeeTitle
        self.employeeTitleId = employeeTitleId
        self.firstName = firstName
        self.lastName = lastName
        self.completed = false
    }
}
