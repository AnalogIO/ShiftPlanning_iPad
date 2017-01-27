//
//  AlertHelper.swift
//  Shiftplanning_iPad
//
//  Created by Frederik Christensen on 1/25/17.
//  Copyright © 2017 Cafe Analog. All rights reserved.
//

import UIKit

class AlertHelper {
    func showSuccess(_ message: String, view: UIViewController) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    func showSuccessPopView(_ message: String, view: UIViewController) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: { _ in
                _ = view.navigationController?.popViewController(animated: true)
        }))
        view.present(alert, animated: true, completion: nil)
    }
    func showAlert(_ message: String, view: UIViewController) {
        let alert = UIAlertController(
            title: "Alert",
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
