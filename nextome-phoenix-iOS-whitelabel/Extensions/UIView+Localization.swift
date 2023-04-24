//
//  UIView+Localization.swift
//  nextome-phoenix-iOS-whitelabel
//
//  Created by Anna Labellarte on 29/03/23.
//

import Foundation
import UIKit

protocol SLocalizable {
    var localized: String { get }
}
extension String: SLocalizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}
extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
   }
}


extension UINavigationItem: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
   }
}

extension UITabBarItem: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
   }
}


extension UITextField: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
    }
}
