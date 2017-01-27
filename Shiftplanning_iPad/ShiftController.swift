//
//  ShiftController.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import UIKit

protocol UpdateShift: class {
    func UpdateShift()
}

class ShiftController: UIViewController, UpdateShift, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var timeLabel: UILabel!
    
    let alertHelper = AlertHelper()
    let nService = NetworkService()
    var shift: Shift? = nil
    var popVC: PopoverVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popVC = self.storyboard?.instantiateViewController(withIdentifier: "popVC") as! PopoverVC
        self.popVC.modalPresentationStyle = .overCurrentContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isCheckedIn(_ emp:Employee, _ shift:Shift) -> Bool {
        for checkIn in shift.checkIns {
            if emp.id == checkIn.employee.id {
                return true
            }
        }
        return false
    }
    
    func checkInPressed(sender:UIButton) {
        nService.checkIn(shiftId: shift!.id, employeeId: sender.tag) { success, response, checkIn in
            if !success {
                self.alertHelper.showAlert(response, view: self)
                return
            }
            self.shift!.checkIns.append(checkIn!)
            self.disableButton(sender)
        }
    }
    
    @IBAction func addEmployee(_ sender: UIButton) {
        nService.getEmployees() { success, response in
            if !success {
                self.alertHelper.showAlert(response, view: self)
                return
            }
            self.present(self.popVC, animated: true, completion: { _ in
                self.popVC.updateDelegate = self
            })
        }
    }
    
    func disableButton(_ button:UIButton) {
        button.backgroundColor = UIColor.lightGray
        button.isEnabled = false
        button.setTitle("Checked in", for: UIControlState.normal)
    }
    
    func enableButton(_ button:UIButton) {
        button.backgroundColor = UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 1.0)
        button.isEnabled = true
        button.setTitle("Check in", for: UIControlState.normal)
    }
    
    func UpdateShift() {
        print("update shift emp")
        var empIds: [Int] = []
        if let selectedEmps = self.popVC.empController?.selectedEmployees {
            for emp in selectedEmps {
                empIds.append(emp.id)
            }
        }
        if empIds.count == 0 {
            return
        }
        nService.addEmployees(employeeIds: empIds, shiftId: self.shift!.id) { success, response, newShift in
            if !success {
                self.alertHelper.showAlert(response, view: self)
                return
            }
            self.shift = newShift
            self.tableView.reloadData()
            for i in 0..<DataRepo.sharedInstance.tShifts.count {
                if DataRepo.sharedInstance.tShifts[i].id == self.shift!.id { DataRepo.sharedInstance.tShifts[i] = newShift! }
            }
            self.alertHelper.showSuccess(response, view: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shift != nil {
            return shift!.employees.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EmpCell
        let emp = self.shift!.employees[indexPath.row]
        cell.nameLabel.text = "\(emp.firstName) \(emp.lastName)"
        cell.checkButton.tag = emp.id
        cell.checkButton.addTarget(self, action: #selector(checkInPressed), for: UIControlEvents.touchUpInside)
        if isCheckedIn(emp, self.shift!) {
            self.disableButton(cell.checkButton)
        } else {
            self.enableButton(cell.checkButton)
        }
        return cell
    }
}
