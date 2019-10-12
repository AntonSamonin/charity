//
//  ViewController.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 16/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HelpViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var helpCategoriesCollectionView: UICollectionView!
    
    private var viewModel = CategoriesViewModel()
    private let activityIndicator = UIActivityIndicatorView()
    private let heartButton = CustomHeartButton()
    private let disposeBag = DisposeBag()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 9.0, bottom: 18.0, right: 9.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeartButtonConstraints(view: tabBarController!.tabBar)
        setupActivityIndicator()
        loadData()
        tabBarController?.delegate = self
        helpCategoriesCollectionView.register(HelpCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        helpCategoriesCollectionView.rx
            .modelSelected(Category.self)
            .bind(onNext: { [weak self] category in
                let charityVC = UIStoryboard(name: "Help", bundle: .main).instantiateViewController(withIdentifier: "CharityEventsVC") as? CharityEventsViewController;
                if let charityVC = charityVC {
                    self?.navigationController?.pushViewController(charityVC, animated: true)
                    charityVC.category = category
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .bind(to: rx.showError)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(text: "Помочь", navBarItem: navigationItem)
    }
    
    private func setupHeartButtonConstraints(view: UIView) {
        view.addSubview(heartButton)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        heartButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        heartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        heartButton.topAnchor.constraint(equalTo: view.topAnchor, constant: -15).isActive = true
    }
    
    private func setupActivityIndicator() {
        helpCategoriesCollectionView.addSubview(activityIndicator)
        activityIndicator.style = .whiteLarge
        activityIndicator.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func loadData() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        viewModel.getCategoriesRx()
            .bind(to: helpCategoriesCollectionView.rx
                .items(cellIdentifier: "CategoryCell",
                       cellType: HelpCategoryCollectionViewCell.self)) {[weak self] row, category, cell in
                        cell.configuration(category: category)
                        self?.activityIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
    }
    
    func alertSetup(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeAppButtonTapped(_ sender: UIBarButtonItem) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
}

extension HelpViewController: UICollectionViewDelegateFlowLayout, NavBarProtocol {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension HelpViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        heartButton.isSelected = tabBarController.selectedIndex == 2 ? true : false
    }
}

extension Reactive where Base: HelpViewController {
    var showError: Binder<LoadDataErrors> {
        return Binder(base) { base, error in
            switch error {
            case .noConnection:
                base.alertSetup(title: "Нет сети", message: "Данные загружены из базы данных.")
            case .serverError:
                base.alertSetup(title: "Ошибка сервера", message: "Данные загружены из Bundle.")
            default: break
            }
        }
    }
}

