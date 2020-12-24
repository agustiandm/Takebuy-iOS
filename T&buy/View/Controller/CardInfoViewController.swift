//
//  CardInfoViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import Stripe


protocol CardInfoViewControllerDelegate {
    func didClickDone(_ token: STPToken)
    func didClickCancel()
}

class CardInfoViewController: UIViewController {

    //MARK: - Properties
    let paymentCardTextField = STPPaymentCardTextField()
    var delegate: CardInfoViewControllerDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
        
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.addSubview(paymentCardTextField)
        
        paymentCardTextField.delegate = self
        
        paymentCardTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 50))
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20))
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20))
    }
    
    //MARK: - Selectors
    @IBAction func doneButtonDidTapped(_ sender: Any) {
        processCard()
    }
    
    @IBAction func cancelButtonDidTapped(_ sender: Any) {
        delegate?.didClickCancel()
        dismissView()
    }
    
    //MARK: - Helper
    private func processCard() {
        
        let cardParams = STPCardParams()
        cardParams.number = paymentCardTextField.cardNumber
        cardParams.expMonth = paymentCardTextField.expirationMonth
        cardParams.expYear = paymentCardTextField.expirationYear
        cardParams.cvc = paymentCardTextField.cvc
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            
            if error == nil {
                self.delegate?.didClickDone(token!)
                self.dismissView()
            } else {
//                print("DEBUG: Error processing card token", error!.localizedDescription)
            }
            
        }
        
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        cancelButton.layer.cornerRadius = 45/2
        cancelButton.clipsToBounds = true
    }
}

extension CardInfoViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        doneButton.isEnabled = textField.isValid
    }
}
