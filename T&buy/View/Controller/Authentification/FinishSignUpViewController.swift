//
//  FinishSignUpViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import JGProgressHUD

class FinishSignUpViewController: UIViewController {
    
    //MARK: - Properties
    var placeholderLabel = UILabel()
    let hud = JGProgressHUD(style: .light)
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldDetection()
    }
    
    //MARK: - Selectors
    @IBAction func doneButtonDidTapped(_ sender: Any) {
        finishOnboarding()
    }
    
//    @IBAction func cancelButtonDidTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateDoneButtonStatus()
    }
    
    //MARK: - Helpers
    private func finishOnboarding() {
        let withValues = [FIRSTNAME : firstNameTextField.text!,
                          LASTNAME : lastNameTextField.text!,
                          ONBOARD : true,
                          FULLADDRESS : addressTextField.text!,
                          FULLNAME : (firstNameTextField.text! + " " + lastNameTextField.text!)] as [String : Any]

        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            
            if error == nil {
                self.hud.textLabel.text = "Updated!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                self.dismiss(animated: true, completion: nil)
            } else {
                
//                print("DEBUG: error updating user \(error!.localizedDescription)")
                
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    func textFieldDetection() {
        firstNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        lastNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
        
    private func updateDoneButtonStatus() {
        
        if firstNameTextField.text != "" && lastNameTextField.text != "" && addressTextField.text != "" {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
            
        }
    }
}
