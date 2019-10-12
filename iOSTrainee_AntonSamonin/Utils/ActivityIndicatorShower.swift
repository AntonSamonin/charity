//
//  ActivityIndicatorShower.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 8/14/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ActivityIndicatorShower: NSObject {
    static let shared = ActivityIndicatorShower()
    static var window: UIWindow?
    
    private let activityIndicatorView: UIActivityIndicatorView
    
    private override init() {
        activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.backgroundColor = .gray
        activityIndicatorView.alpha = 0.5
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    
    fileprivate func showActivityIndicator() {
        guard let window = ActivityIndicatorShower.window else {
            return
        }
        
        activityIndicatorView.frame = window.frame
        activityIndicatorView.center = window.center
        
        window.addSubview(activityIndicatorView)
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    fileprivate func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
        
        activityIndicatorView.removeFromSuperview()
    }
}

extension Reactive where Base: ActivityIndicatorShower {
    var isLoading: Binder<Bool> {
        return Binder(base) { base, isLoading in
            guard isLoading else {
                base.hideActivityIndicator()
                return
            }
            
            base.showActivityIndicator()
        }
    }
}

