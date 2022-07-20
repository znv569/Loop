//
//  UIViewController.swift
//  Loop
//
//  Created by Pete Schwamb on 8/26/20.
//  Copyright © 2020 LoopKit Authors. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

extension UIViewController {
    var topmostViewController: UIViewController {
        if let tabController = self as? UITabBarController {
            return tabController.selectedViewController?.topmostViewController ?? self
        }
        if let navController = self as? UINavigationController {
            return navController.visibleViewController?.topmostViewController ?? self
        }
        return presentedViewController?.topmostViewController ?? self
    }

    /// Argumentless wrapper around `dismiss(animated:)` in order to pass as a selector
    @objc func dismissWithAnimation() {
        dismiss(animated: true)
    }
    
    static let hud = JGProgressHUD(style: .dark)
    func hideKeyboardOnTap(_ selector: Selector, viewTap: UIView? = nil) {
        
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
           tap.cancelsTouchesInView = false
        
        if let viewTap = viewTap {
           viewTap.addGestureRecognizer(tap)
        }else{
            view.addGestureRecognizer(tap)
        }
    }

    func showLoader(_ show: Bool) {
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
