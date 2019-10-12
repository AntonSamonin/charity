//
//  CharityEventsViewController.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 19/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CharityEventsViewController: UIViewController, NavBarProtocol {
    
    private var viewModel = EventsViewModel()
    private let activityIndicator = UIActivityIndicatorView()
    private let disposeBag = DisposeBag()
    var category: Category?
    
    @IBOutlet weak var charityEventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupView()
        loadData()
        
        charityEventsTableView.rx
            .modelSelected(Event.self)
            .subscribe(onNext: { [weak self] event in
                let charityEventDescriptionVC = UIStoryboard(name: "Help", bundle: .main).instantiateViewController(withIdentifier: "CharityEventDescriptionVC") as? CharityEventDescriptionViewController;
                if let charityEventDescriptionVC = charityEventDescriptionVC {
                    self?.navigationController?.pushViewController(charityEventDescriptionVC, animated: true)
                    self?.tabBarController?.tabBar.isHidden = true
                    charityEventDescriptionVC.event = event
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .bind(to: rx.showError)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backButton")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButton")
        charityEventsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private func setupActivityIndicator() {
        charityEventsTableView.addSubview(activityIndicator)
        activityIndicator.style = .whiteLarge
        activityIndicator.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupView() {
        charityEventsTableView.register(UINib(nibName: "CharityEventTableViewCell", bundle: nil), forCellReuseIdentifier: "CharityCell")
        if let category = self.category, let categoryType = category.categoryType {
            setupNavigationBar(text: categoryType.rawValue, navBarItem: navigationItem)
        }
    }
    
    private func loadData() {
        if let category = self.category {
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            viewModel.getEventsRx(for: category)
                .bind(to: charityEventsTableView.rx
                    .items(cellIdentifier: "CharityCell",
                           cellType: CharityEventTableViewCell.self)) { [weak self] row, event, cell in
                            cell.configuration(event: event, viewModel: self!.viewModel)
                            self?.activityIndicator.stopAnimating()
                }
                .disposed(by: disposeBag)
        }
    }
    
    func alertSetup(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension Reactive where Base: CharityEventsViewController {
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

