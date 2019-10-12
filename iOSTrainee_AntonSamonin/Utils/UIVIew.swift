//
//  UIVIew.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 19/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        } get {
            return layer.cornerRadius
        }
    }
}
