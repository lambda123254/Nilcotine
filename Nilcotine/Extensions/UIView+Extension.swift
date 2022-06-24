//
//  UIView+Extension.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 24/06/22.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {return cornerRadius}
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
