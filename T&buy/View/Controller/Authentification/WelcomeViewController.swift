//
//  WelcomeViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class WelcomeViewController: UIViewController {
    
    //MARK: - Properties
    let hud = JGProgressHUD(style: .light)
    var activityIndicator: NVActivityIndicatorView?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30,
                                                                  y: self.view.frame.height / 2 - 30,
                                                                  width: 50,
                                                                  height: 50),
                                                    type: .lineSpinFadeLoader,
                                                    color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), padding: nil)
    }

    

    //MARK: - Navigation
//    private func showHome() {
//        let homeView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "homeVC") as! HomeViewController
//        self.present(homeView, animated: true, completion: nil)
//    }
    
    private func configureBackButton() {
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                                  style: .plain,
                                                                  target: self, action: #selector(self.backAction))]
    }
    
    //MARK: - Selectors
    @IBAction func loginButtonDidTapped(_ sender: Any) {
        if textFieldsHaveText() {
            loginUser()
        } else {
            hud.textLabel.text = "All fields are required!"
            hud.sizeToFit()
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func signupButtonDidTapped(_ sender: Any) {
//        print("DEBUG: Signup success")
        
        if textFieldsHaveText() {
            signupUser()
        } else {
            hud.textLabel.text = "All fields are required!"
            hud.sizeToFit()
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func resendEmailButtonDidTapped(_ sender: Any) {
//        print("DEBUG: Resend email")
        
        User.resendVerificationEmail(email: emailTextField.text!) { (error) in
//            print("DEBUG: Error resending email", error!.localizedDescription)
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Login User
    private func loginUser() {
        
        showLoadingIdicator()
        
        User.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                if  isEmailVerified {
                    self.dismissView()
//                    print("DEBUG: Email is verified")
                } else {
                    self.hud.textLabel.text = "Please verify your email!"
                    self.hud.sizeToFit()
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    self.resendButton.isHidden = false
                }
            } else {
//                print("DEBUG: Error loging user", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.sizeToFit()
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideLoadingIdicator()
        }
    }
    
    //MARK: - Register User
    private func signupUser() {
        showLoadingIdicator()
        User.signupUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            if error == nil {
                self.hud.textLabel.text = "Verification email sent!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
//                print("DEBUG: Error signup!", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideLoadingIdicator()
        }
    }
    
    //MARK: - Helper
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    private func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Activity Indicator
    private func showLoadingIdicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIdicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }

    
}
