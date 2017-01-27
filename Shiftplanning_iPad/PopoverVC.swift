//
//  PopoverVC.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import UIKit

class PopoverVC: UIViewController {
    
    var empController: EmpController?
    weak var updateDelegate: UpdateShift?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        updateDelegate?.UpdateShift()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EmpController, segue.identifier == "empSegue" {
            self.empController = vc
        }
    }
}
