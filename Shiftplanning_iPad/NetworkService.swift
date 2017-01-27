//
//  NetworkService.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import ReachabilitySwift

class NetworkService {
    
    let reachability = Reachability()!
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
    let baseUrl = "https://analogio.dk/shiftplanning/api/"
    let dataRepo = DataRepo.sharedInstance
    let jParser = JsonParser()
    
    init() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setBackgroundColor(UIColor(red: 251/255, green: 176/255, blue: 59/255, alpha: 1.0))
    }
    
    func checkIn(shiftId:Int, employeeId:Int, completion:@escaping (_ success: Bool, _ response: String, _ checkIn: CheckIn?) -> Void) {
        if !reachability.isReachable {
            completion(false,"No internet connection", nil)
            return
        }
        let url = "\(baseUrl)shifts/\(shiftId)/checkin?employeeId=\(employeeId)"
        let headers = [
            "Authorization": Config.apiKey
        ]
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, encoding:JSONEncoding.default, headers: headers)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                print(response)
                switch response.response!.statusCode {
                case 200..<300:
                    if let checkInDict = response.result.value as? NSDictionary {
                        let checkIn = self.jParser.parseCheckIn(checkInDict)
                        completion(true, "Successfully checked in employee", checkIn)
                    }
                    break;
                case 500..<600:
                    completion(false, "Server error, try again later.", nil)
                    break;
                default:
                    var msg = "Status code: \(response.response!.statusCode)"
                    if let jsonDict = response.result.value as? NSDictionary,
                        let message = jsonDict["message"] as? String {
                        msg = message
                    }
                    completion(false, msg, nil)
                    break;
                }
        }
    }
    
    func getEmployees(completion:@escaping (_ success: Bool, _ response: String) -> Void) {
        if !reachability.isReachable {
            completion(false,"No internet connection")
            return
        }
        let url = "\(baseUrl)employees?apiKey=\(Config.apiKey)"
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, encoding:JSONEncoding.default, headers: [:])
            .responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.response!.statusCode {
                case 200..<300:
                    if let empArr = response.result.value as? NSArray {
                        self.dataRepo.employees = self.jParser.parseEmployees(empArr)
                        completion(true,"Successfully fetched employees")
                    }
                    break;
                case 500..<600:
                    completion(false, "Server error, try again later.")
                    break;
                default:
                    var msg = "Status code: \(response.response!.statusCode)"
                    if let jsonDict = response.result.value as? NSDictionary,
                        let message = jsonDict["message"] as? String {
                        msg = message
                    }
                    completion(false, msg)
                    break;
                }
        }
    }
    
    func createShift(from:String, to:String, employeeIds:[Int], completion:@escaping (_ success: Bool, _ response: String) -> Void) {
        if !reachability.isReachable {
            completion(false,"No internet connection")
            return
        }
        let url = "\(baseUrl)shifts/createoutsideschedule"
        let headers = [
            "Authorization": Config.apiKey
        ]
        let parameters = [
            "employeeIds": employeeIds,
            "start": from,
            "end": to
            ] as [String : Any]
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, parameters: parameters, encoding:JSONEncoding.default, headers: headers)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.response!.statusCode {
                case 200..<300:
                    if let shiftDict = response.result.value as? NSDictionary {
                        self.dataRepo.tShifts.append(self.jParser.parseShift(shiftDict))
                    }
                    completion(true, "Successfully created shift!")
                    break;
                case 500..<600:
                    completion(false, "Server error, try again later.")
                    break;
                default:
                    var msg = "Status code: \(response.response!.statusCode)"
                    if let jsonDict = response.result.value as? NSDictionary,
                        let message = jsonDict["message"] as? String {
                        msg = message
                    }
                    completion(false, msg)
                    break;
                }
        }
    }
    
    func todaysShifts(completion:@escaping (_ success: Bool, _ response: String) -> Void) {
        if !reachability.isReachable {
            completion(false,"No internet connection")
            return
        }
        let url = "\(baseUrl)shifts/today"
        let headers = [
            "Authorization": Config.apiKey
        ]
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, encoding:JSONEncoding.default, headers: headers)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.response!.statusCode {
                case 200..<300:
                    if let shiftArr = response.result.value as? NSArray {
                        self.dataRepo.tShifts = self.jParser.parseShifts(shiftArr)
                        completion(true,"Successfully fetched todays shifts")
                    }
                    break;
                case 500..<600:
                    completion(false, "Server error, try again later.")
                    break;
                default:
                    var msg = "Status code: \(response.response!.statusCode)"
                    if let jsonDict = response.result.value as? NSDictionary,
                        let message = jsonDict["message"] as? String {
                        msg = message
                    }
                    completion(false, msg)
                    break;
                }
        }
    }
    
    func addEmployees(employeeIds:[Int], shiftId:Int, completion:@escaping (_ success: Bool, _ response: String, _ shift: Shift?) -> Void) {
        if !reachability.isReachable {
            completion(false,"No internet connection", nil)
            return
        }
        let url = "\(baseUrl)shifts/\(shiftId)/addEmployees"
        let headers = [
            "Authorization": Config.apiKey
        ]
        let parameters = [
            "employeeIds": employeeIds
            ] as [String : Any]
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, parameters: parameters, encoding:JSONEncoding.default, headers: headers)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.response!.statusCode {
                case 200..<300:
                    if let shiftDict = response.result.value as? NSDictionary {
                        let newShift = self.jParser.parseShift(shiftDict)
                        completion(true, "Successfully added employees to shift!", newShift)
                    }
                    break;
                case 500..<600:
                    completion(false, "Server error, try again later.", nil)
                    break;
                default:
                    var msg = "Status code: \(response.response!.statusCode)"
                    if let jsonDict = response.result.value as? NSDictionary,
                        let message = jsonDict["message"] as? String {
                        msg = message
                    }
                    completion(false, msg, nil)
                    break;
                }
        }
    }
}
