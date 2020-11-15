//
//  UIViewController+Ext_ShowError.swift
//  MailWeather
//
//  Created by Maxim on 15.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

extension UIViewController {
    public func show(_ description: String) {
        let alertVC = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}
