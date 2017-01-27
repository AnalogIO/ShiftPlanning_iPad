//
//  CreateShiftController.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import UIKit

protocol UpdateEmployees: class {
    func updateEmployees()
}

class CreateShiftController: UIViewController, UpdateEmployees {

    @IBOutlet var toPicker: UIDatePicker!
    @IBOutlet var fromPicker: UIDatePicker!
    @IBOutlet var empSelected: UILabel!
    @IBOutlet var selectEmp: UIButton!
    var popVC: PopoverVC!
    let nService = NetworkService()
    let alertHelper = AlertHelper()
    weak var updateDelegate: UpdateShifts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popVC = self.storyboard?.instantiateViewController(withIdentifier: "popVC") as! PopoverVC
        self.popVC.modalPresentationStyle = .overCurrentContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func empPressed(_ sender: UIButton) {
        self.present(self.popVC, animated: true, completion: { _ in
            self.popVC.empController?.updateDelegate = self
        })
    }
    
    @IBAction func createShift(_ sender: UIButton) {
        let from = "\(fromPicker.date.hour()):\(fromPicker.date.minute())"
        let to = "\(toPicker.date.hour()):\(toPicker.date.minute())"
        var empIds:[Int] = []
        if let emps = self.popVC.empController?.selectedEmployees {
            for emp in emps {
                empIds.append(emp.id)
            }
        }
        self.nService.createShift(from: from, to: to, employeeIds: empIds) { success, response in
            if !success {
                self.alertHelper.showAlert(response, view: self)
                return
            }
            self.updateDelegate?.updateShifts()
            self.alertHelper.showSuccess(response, view: self)
        }
    }
    
    func updateEmployees() {
        print("update create emp")
        let empArr = popVC.empController!.selectedEmployees
        if empArr.isEmpty {
            self.empSelected.text = "None"
            return
        }
        var empString = ""
        for i in 0..<empArr.count {
            let emp = empArr[i]
            if i == 0 {
                empString = "\(empString) \(emp.firstName)"
            } else {
                empString = "\(empString) & \(emp.firstName)"
            }
        }
        self.empSelected.text = empString
    }
}
