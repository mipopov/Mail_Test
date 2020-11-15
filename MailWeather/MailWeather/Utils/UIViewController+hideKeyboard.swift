//
//  UIViewController+hideKeyboard.swift
//  MailWeather
//
//  Created by Maxim on 15.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
