//
//  EditProfileViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    var placeholderLabel = UILabel()
    let hud = JGProgressHUD(style: .light)

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!

    
    //AMRK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserInfo()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationItem.backBarButtonItem = .none
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isHidden = false
//    }

    //MARK: - Selectors
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        dismissKeyboard()
        
        if textFieldsHaveText() {
            
            let withValues = [FIRSTNAME : firstNameTextField.text!, LASTNAME : lastnameTextField.text!, FULLNAME : (firstNameTextField.text! + " " + lastnameTextField.text!), FULLADDRESS : addressTextView.text!]
            
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                
                if error == nil {
                    self.hud.textLabel.text = "Updated!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                } else {
//                    print("DEBUG: error updating user ", error!.localizedDescription)
                   self.hud.textLabel.text = error!.localizedDescription
                   self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                   self.hud.show(in: self.view)
                   self.hud.dismiss(afterDelay: 2.0)
                }
            }
            
        } else {
            hud.textLabel.text = "All fields are required!"
            hud.sizeToFit()
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
    @IBAction func signoutDidTapped(_ sender: Any) {
        signOutUser()
    }
//    
//    @IBAction func closeDidTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    //MARK: - UpdateUI
    
    private func loadUserInfo() {
        
        if User.currentUser() != nil {
            let currentUser = User.currentUser()!
            
            firstNameTextField.text = currentUser.firstName
            lastnameTextField.text = currentUser.lastName
            addressTextView.text = currentUser.fullAddress
        }
    }

    //MARK: - Helper
    private func signOutUser() {
        User.signOutCurrentUser { (error) in
            
            if error == nil {
//                print("DEBUG: Sign Out Success")
                self.navigationController?.popViewController(animated: true)
            }  else {
//                print("DEBUG: Error sign out ", error!.localizedDescription)
            }
        }
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func textFieldsHaveText() -> Bool {
        return (firstNameTextField.text != "" && lastnameTextField.text != "" && addressTextView.text != "")
    }
}
