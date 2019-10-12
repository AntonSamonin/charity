//
//  AuthorizationViewController.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 8/6/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

// MARK: - Properties

class AuthorizationViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let handle = Auth.auth().addStateDidChangeListener { (auth, user) in }
    private let activityIndicator = UIActivityIndicatorView()
    private let viewModel = AuthorizationViewModel()
    
    @IBOutlet private weak var vkAuthorizationButton: UIButton!
    @IBOutlet private weak var fbAuthorizationButton: UIButton!
    @IBOutlet private weak var okAuthorizationButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordRecoveryTextView: UITextView!
    @IBOutlet private weak var registrationButton: UIButton!
    @IBOutlet private weak var hidePasswordButton: UIButton!
}

// MARK: - Life Cycle

extension AuthorizationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(text: "Авторизация", navBarItem: navigationItem)
        setupActivityIndicator()
        
        emailTextField.rx.text
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.login)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.allowEntry
            .drive(loginButton.rx.isEnabledWithAlpha)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.loginTap)
            .disposed(by: disposeBag)
        
        viewModel.singIn()
            .drive()
            .disposed(by: disposeBag)
        
        vkAuthorizationButton.rx.tap
            .bind(to: viewModel.vkTap)
            .disposed(by: disposeBag)
        
        fbAuthorizationButton.rx.tap
            .bind(to: viewModel.fbTap)
            .disposed(by: disposeBag)
        
        okAuthorizationButton.rx.tap
            .bind(to: viewModel.okTap)
            .disposed(by: disposeBag)
        
        viewModel.socialNetworkSignIn()
            .drive()
            .disposed(by: disposeBag)
        
        viewModel.keyboardHeight
            .bind(onNext: { [weak self] notification in
                self?.keyBoardSetUp(notification: notification)
            })
            .disposed(by: disposeBag)
        
        viewModel.signedIn
            .bind(onNext: { [disposeBag] success in
                if success {
                    DefaultWireframe.shared.promptFor("Успешный вход.", cancelAction: "OK", actions: [])
                        .subscribe(onNext: { [weak self] _ in
                            self?.navigationController?.popViewController(animated: true)
                        })
                        .disposed(by: disposeBag)
                } else {
                    DefaultWireframe.shared.promptFor("Не удалось войти.", cancelAction: "OK", actions: [])
                        .subscribe()
                        .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        registrationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showRegistrationAlert()
            })
            .disposed(by: disposeBag)
        
        viewModel.loading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.loading
            .drive(onNext:{ [weak self] loading in
                if loading {
                    self?.loginButton.setTitle("", for: .normal)
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.loginButton.setTitle("Войти", for: .normal)
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle)
    }
}

// MARK: - Setups

extension AuthorizationViewController: NavBarProtocol {
    
    private func keyBoardSetUp(notification: Notification) {
        if let keyBoardRect =  (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyBoardRect.height/2
        } else {
            view.frame.origin.y = 0
        }
    }
    
    private func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    private func showRegistrationAlert() {
        let alertView = UIAlertController(title: "Регистрация",
                                          message: "",
                                          preferredStyle: .alert)
        
        alertView.addTextField{ $0.placeholder = "Введите email"}
        alertView.addTextField{ $0.placeholder = "Введите пароль"}
        
        let emailValid = alertView.textFields?[0].rx.text.orEmpty
            .map{$0.count >= 5 && $0.contains("@")}
            .share(replay: 1)
        let passwordValid = alertView.textFields?[1].rx.text.orEmpty
            .map{$0.count >= 5}
            .share(replay: 1)
        let everythingValid = Observable
            .combineLatest(emailValid!, passwordValid!) { $0 && $1 }
            .share(replay: 1)
        
        let registrationAction = UIAlertAction(title: "Зарегистрироваться",
                                               style: .default) { [weak self] _ in
                                                Auth.auth().createUser(withEmail: (alertView.textFields?[0].text)!,
                                                                       password: (alertView.textFields?[1].text)!,
                                                                       completion: { (result, error) in
                                                                        if result != nil {
                                                                            print("Регистрация прошла успешно!")
                                                                            self?.navigationController?.popViewController(animated: true)
                                                                        }
                                                })
        }
        
        alertView.addAction(registrationAction)
        alertView.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        everythingValid
            .bind(to: alertView.actions[0].rx.isEnabled)
            .disposed(by: disposeBag)
        present(alertView, animated: true)
    }
    
    private func setupActivityIndicator() {
        loginButton.addSubview(activityIndicator)
        activityIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 15).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 15).isActive = true
        activityIndicator.hidesWhenStopped = true
    }
}
