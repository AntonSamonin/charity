//
//  UIButtonReactiveExtension.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 8/27/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIButton {
    var isEnabledWithAlpha: Binder<Bool> {
        return Binder(base) { button, isEnabled in
            button.isEnabled = isEnabled
            button.alpha = isEnabled ? 1 : 0.5
        }
    }
}
