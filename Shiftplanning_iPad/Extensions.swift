//
//  Extensions.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import Foundation

extension Date {
    
    private func components() -> DateComponents  {
        return Calendar.current.dateComponents(in: TimeZone(identifier: "Europe/Copenhagen")!, from: self)
    }
    
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func isInBetween(date1: Date, date2: Date) -> Bool {
        var between = false
        if date1.isLessThanDate(dateToCompare: self) && self.isLessThanDate(dateToCompare: date2) {
            between = true
        }
        return between
    }
    
    func year () -> String {
        if self.components().year!.description.characters.count == 1 {
            return "0\(self.components().year!)"
        } else {
            return "\(self.components().year!)"
        }
    }
    
    func month () -> String {
        if self.components().month!.description.characters.count == 1 {
            return "0\(self.components().month!)"
        } else {
            return "\(self.components().month!)"
        }
    }
    
    func day () -> String {
        if self.components().day!.description.characters.count == 1 {
            return "0\(self.components().day!)"
        } else {
            return "\(self.components().day!)"
        }
    }
    
    func hour () -> String {
        if self.components().hour!.description.characters.count == 1 {
            return "0\(self.components().hour!)"
        } else {
            return "\(self.components().hour!)"
        }
    }
    
    func minute () -> String {
        if self.components().minute!.description.characters.count == 1 {
            return "0\(self.components().minute!)"
        } else {
            return "\(self.components().minute!)"
        }
    }
    
    func seconds () -> String {
        if self.components().second!.description.characters.count == 1 {
            return "0\(self.components().second!)"
        } else {
            return "\(self.components().second!)"
        }
    }
    
    func weekDay() -> String {
        switch Calendar.current.dateComponents([.weekday], from: self).weekday! {
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        case 1:
            return "Sun"
        default:
            print("Default")
        }
        return "-1"
    }
}
