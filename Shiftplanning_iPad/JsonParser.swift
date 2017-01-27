//
//  JsonParser.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import Foundation

class JsonParser {
    
    let dateFormatter : DateFormatter
    
    init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.locale = Locale(identifier: "da_DK_POSIX")
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    func parseShifts(_ json:NSArray) -> [Shift] {
        var shiftArr : [Shift] = []
        for i in 0..<json.count {
            if let shiftDict = json[i] as? NSDictionary,
                let startString = shiftDict["start"] as? String,
                let endString = shiftDict["end"] as? String,
                let startDate = self.dateFormatter.date(from: startString),
                let endDate = self.dateFormatter.date(from: endString),
                let empArr = shiftDict["employees"] as? NSArray,
                let checkInsArr = shiftDict["checkIns"] as? NSArray,
                let id = shiftDict["id"] as? Int {
                let employees = self.parseEmployees(empArr)
                let checkIns = self.parseCheckIns(checkInsArr)
                shiftArr.append(Shift(id: id, start: startDate, end: endDate, employees: employees, checkIns: checkIns))
            }
        }
        return shiftArr
    }
    
    func parseShift(_ shiftDict:NSDictionary) -> Shift {
        var shift : Shift!
        if let startString = shiftDict["start"] as? String,
            let endString = shiftDict["end"] as? String,
            let startDate = self.dateFormatter.date(from: startString),
            let endDate = self.dateFormatter.date(from: endString),
            let empArr = shiftDict["employees"] as? NSArray,
            let checkInsArr = shiftDict["checkIns"] as? NSArray,
            let id = shiftDict["id"] as? Int {
            let employees = self.parseEmployees(empArr)
            let checkIns = self.parseCheckIns(checkInsArr)
            shift = Shift(id: id, start: startDate, end: endDate, employees: employees, checkIns: checkIns)
        }
        return shift
    }
    
    func parseEmployees(_ json:NSArray) -> [Employee] {
        var empArr : [Employee] = []
        for i in 0..<json.count {
            if let empDict = json[i] as? NSDictionary,
                let id = empDict["id"] as? Int,
                let employeeTitle = empDict["employeeTitle"] as? String,
                let employeeTitleId = empDict["employeeTitleId"] as? Int,
                let firstName = empDict["firstName"] as? String,
                let lastName = empDict["lastName"] as? String {
                
                empArr.append(Employee(id: id, employeeTitle: employeeTitle, employeeTitleId: employeeTitleId, firstName: firstName, lastName: lastName))
            }
        }
        return empArr
    }
    
    func parseCheckIns(_ json:NSArray) -> [CheckIn] {
        var checkInsArr : [CheckIn] = []
        for i in 0..<json.count {
            if let checkInsDict = json[i] as? NSDictionary,
                let id = checkInsDict["id"] as? Int,
                let timeString = checkInsDict["time"] as? String,
                let timeDate = self.dateFormatter.date(from: timeString),
                let employeeDict = checkInsDict["employee"] as? NSDictionary {
                let employeeArr = self.parseEmployees([employeeDict])
                if let employee = employeeArr.first {
                    checkInsArr.append(CheckIn(id: id, time: timeDate, employee: employee))
                }
            }
        }
        return checkInsArr
    }
    
    func parseCheckIn(_ checkInDict:NSDictionary) -> CheckIn {
        var checkIn : CheckIn!
        if let id = checkInDict["id"] as? Int,
        let timeString = checkInDict["time"] as? String,
        let timeDate = self.dateFormatter.date(from: timeString),
        let employeeDict = checkInDict["employee"] as? NSDictionary {
            let employeeArr = self.parseEmployees([employeeDict])
            if let employee = employeeArr.first {
                checkIn = CheckIn(id: id, time: timeDate, employee: employee)
            }
        }
        return checkIn
    }
}
