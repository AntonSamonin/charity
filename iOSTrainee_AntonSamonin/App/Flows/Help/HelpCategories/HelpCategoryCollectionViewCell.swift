//
//  HelpCategoryCollectionViewCell.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 18/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit

class HelpCategoryCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private let categoryImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.619256556, green: 0.7496322989, blue: 0.3142116964, alpha: 1)
        label.font = UIFont.categoryHelp
        return label
    }()
    
    
    func setupView() {
        addSubview(categoryImageView)
        addSubview(categoryLabel)
        
        self.backgroundColor = #colorLiteral(red: 0.9194837213, green: 0.9301566482, blue: 0.9078676105, alpha: 1)
        categoryImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        categoryImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15).isActive = true
        
        categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configuration(category: Category) {
        self.categoryLabel.text = category.name
        
        if let categoryType = category.categoryType {
            switch categoryType {
            case .adults:
                categoryImageView.image = UIImage(named: "adults")
            case .animals:
                categoryImageView.image = UIImage(named: "animals")
            case .children:
                categoryImageView.image = UIImage(named: "children")
            case .elderly:
                categoryImageView.image = UIImage(named: "grandma")
            case .events:
                categoryImageView.image = UIImage(named: "events")
            }
        }
    }
}
