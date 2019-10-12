//
//  DefaultWireframe.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 8/12/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DefaultWireframe: Wireframe {
    
    static let shared = DefaultWireframe()

    func promptFor<Action>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> where Action : CustomStringConvertible {

        return Observable.create { observer in
            let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))

            })
            
            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                })
            }
            
            if let topVC = UIApplication.topViewController() {
                topVC.present(alertView, animated: true)
            }

            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }
    }
}
