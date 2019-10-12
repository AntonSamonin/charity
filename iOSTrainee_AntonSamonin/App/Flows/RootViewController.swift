//
//  RootViewController.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 10/7/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private var current: UIViewController
    
    init() {
        current = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: "SplashVC")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
     }
    
    func showTabBar(tabBar: UITabBarController) {
        let new = UINavigationController(rootViewController: tabBar)
        new.navigationBar.isHidden = true
        addChild(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = new
     }
}
