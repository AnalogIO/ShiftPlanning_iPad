//
//  EmpController.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import UIKit

extension EmpController: UISearchResultsUpdating {
    func updateSearchResults(for: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class EmpController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var filteredEmployees:[Employee] = []
    var selectedEmployees:[Employee] = []
    var employees = DataRepo.sharedInstance.employees
    weak var updateDelegate: UpdateEmployees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredEmployees = employees.filter { emp in
            let fullName = "\(emp.firstName) \(emp.lastName)"
            return fullName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredEmployees.count
        }
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var emp:Employee
        if searchController.isActive && searchController.searchBar.text != "" {
            emp = filteredEmployees[indexPath.row]
        } else {
            emp = employees[indexPath.row]
        }
        cell.textLabel?.text = "\(emp.firstName) \(emp.lastName)"
        if emp.completed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)!
        var emp: Employee
        if searchController.isActive && searchController.searchBar.text != "" {
            emp = filteredEmployees[indexPath.row]
        } else {
            emp = employees[indexPath.row]
        }
        if !emp.completed {
            cell.accessoryType = .checkmark
            self.selectedEmployees.append(emp)
            updateDelegate?.updateEmployees()
        } else {
            cell.accessoryType = .none
            let empIndex = self.selectedEmployees.index{$0 === emp}
            self.selectedEmployees.remove(at: empIndex!)
            updateDelegate?.updateEmployees()
        }
        emp.completed = !emp.completed
        tableView.reloadData()
    }
}
