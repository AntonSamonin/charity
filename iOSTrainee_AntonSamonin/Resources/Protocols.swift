//
//  Protocols.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 8/21/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol NavBarProtocol {
    func setupNavigationBar(text: String, navBarItem: UINavigationItem)
}

extension NavBarProtocol {
    func setupNavigationBar(text: String, navBarItem: UINavigationItem) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        label.text = text
        label.font = UIFont(name: "OfficinaSansExtraBoldSCC", size: 21)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navBarItem.titleView = label
        navBarItem.backBarButtonItem?.title = ""
    }
}

protocol Wireframe {
    func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

protocol ValidationServiceDelegate {
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
}
