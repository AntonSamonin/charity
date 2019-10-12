//
//  CustomHeartButton.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 7/27/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit

class CustomHeartButton: UIButton {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        layer.cornerRadius = 22
        layer.shadowColor = #colorLiteral(red: 0.7018982768, green: 0.7020009756, blue: 0.7018757463, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.9
        layer.masksToBounds = false
        clipsToBounds = false
        setImage(#imageLiteral(resourceName: "greenheart"), for: .normal)
        setImage(#imageLiteral(resourceName: "redheart"), for: .selected)
        isUserInteractionEnabled = false
        isSelected = true
    }
}
