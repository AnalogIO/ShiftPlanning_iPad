//
//  ViewController.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import UIKit

protocol UpdateShifts: class {
    func updateShifts()
}

class StartController: UIViewController, UpdateShifts, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var createShiftContainer: UIView!
    @IBOutlet var shiftContainer: UIView!
    let nService = NetworkService()
    let alertHelper = AlertHelper()
    let dataRepo = DataRepo.sharedInstance
    var shiftController: ShiftController?
    var cShiftController: CreateShiftController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nService.todaysShifts() { success, response in
            if !success {
                self.alertHelper.showAlert(response, view: self)
                return
            }
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        nService.getEmployees() { success, response in
            if !success {
                self.alertHelper.showAlert(response, view: self)
                return
            }
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
            self.shiftContainer.isHidden = true
            self.createShiftContainer.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShiftController, segue.identifier == "shiftSegue" {
            self.shiftController = vc
        }
        if let vc = segue.destination as? CreateShiftController, segue.identifier == "cShiftSegue" {
            self.cShiftController = vc
            self.cShiftController?.updateDelegate = self
        }
    }
    
    func updateShifts() {
        self.tableView.reloadData()
        let indexPath = IndexPath(row: dataRepo.tShifts.count-1, section: 0);
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        self.tableView(self.tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataRepo.tShifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ShiftCell
        let shift = self.dataRepo.tShifts[indexPath.row]
        cell.timeLabel.text = "\(shift.start.hour()):\(shift.start.minute()) - \(shift.end.hour()):\(shift.end.minute())"
        let selection = UIView()
        selection.backgroundColor = UIColor(red: 251/255, green: 176/255, blue: 59/255, alpha: 1.0)
        cell.selectedBackgroundView = selection
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ShiftCell
        shiftContainer.isHidden = false
        createShiftContainer.isHidden = true
        shiftController?.timeLabel.text = cell.timeLabel.text
        shiftController?.shift = dataRepo.tShifts[indexPath.row]
        shiftController?.tableView.reloadData()
    }
}

