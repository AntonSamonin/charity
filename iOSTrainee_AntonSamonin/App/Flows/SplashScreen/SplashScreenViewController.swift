//
//  SplashScreenViewController.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 18/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeServiceCall()
    }
    
    private func makeServiceCall() {
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.switchToTabBarVC()
        }
    }
    
    private func switchToTabBarVC() {
        let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        tabBarVC.selectedIndex = 2
        AppDelegate.shared.rootViewController.showTabBar(tabBar: tabBarVC)
    }
}

