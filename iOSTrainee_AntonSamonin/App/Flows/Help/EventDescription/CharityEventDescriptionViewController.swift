//
//  EventDesctiptionViewController.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 22/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CharityEventDescriptionViewController: UIViewController {
    
    var event: Event?
    private var viewModel = EventDescriptionViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak private var eventTitleLabel: UILabel!
    @IBOutlet weak private var eventDateLabel: UILabel!
    @IBOutlet weak private var charityOrganizationLabel: UILabel!
    @IBOutlet weak private var charityOrganizationAddressLabel: UILabel!
    @IBOutlet weak private var charityOrganizationContactsLabel: UILabel!
    @IBOutlet weak private var eventDescriptionLabel: UILabel!
    @IBOutlet weak private var whriteToUsTextView: UITextView!
    @IBOutlet weak private var helpClothesButton: UIButton!
    @IBOutlet weak private var becomeAVolunteerButton: UIButton!
    @IBOutlet weak private var professionalHelpButton: UIButton!
    @IBOutlet weak private var moneyHelpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        helpClothesButton.rx.tap
            .bind(to: viewModel.helpClothesTap)
            .disposed(by: disposeBag)
        
        becomeAVolunteerButton.rx.tap
            .bind(to: viewModel.becomeAVolunteerTap)
            .disposed(by: disposeBag)
        
        professionalHelpButton.rx.tap
            .bind(to: viewModel.professionalHelpTap)
            .disposed(by: disposeBag)
        
        moneyHelpButton.rx.tap
            .bind(to: viewModel.moneyHelpTap)
            .disposed(by: disposeBag)
        
        viewModel.needAuth
            .drive(onNext: { [weak self] _ in
                let authVC =  UIStoryboard(name: "Authorization", bundle: .main).instantiateViewController(withIdentifier: "authController") as? AuthorizationViewController
                if let authVC = authVC {
                    self?.navigationController?.pushViewController(authVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupView() {
        if let event = event {
            setupNavigationBar(text: event.title, navBarItem: navigationItem)
            eventTitleLabel.text = event.title
            eventDateLabel.text = viewModel.eventDateFormatter(eventDate: event.date)
            charityOrganizationLabel.text = event.organizationName
            charityOrganizationAddressLabel.text = event.organizationAddress
            charityOrganizationContactsLabel.text = event.phoneNumbers
            eventDescriptionLabel.text = event.eventDescription
            setupWhriteToUs()
        }
    }
    
    private func setupWhriteToUs() {
        let attrebutedStr = NSMutableAttributedString(string: "У вас есть вопросы? Напишите нам!")
        attrebutedStr.addAttribute(.link, value: "https://www.google.com", range: NSRange(location: 20, length: 13))
        attrebutedStr.addAttributes([ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ], range: NSRange(location: 20, length: 13))
        attrebutedStr.addAttributes([NSAttributedString.Key.font : UIFont.textStyle4], range: NSRange(location: 0, length: 19))
        attrebutedStr.addAttributes([NSAttributedString.Key.font : UIFont.textStyle5], range: NSRange(location: 20, length: 13))
        attrebutedStr.addAttributes([ NSAttributedString.Key.foregroundColor: UIColor(red: 73.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)], range: NSRange(location: 0, length: 19))
        whriteToUsTextView.linkTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 102.0 / 255.0, green: 166.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)]
        whriteToUsTextView.isEditable = false
        whriteToUsTextView.attributedText = attrebutedStr
    }
}

extension CharityEventDescriptionViewController: UITextViewDelegate, NavBarProtocol {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}


