//
//  ResetViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class ResetViewController: UIViewController {

    //MARK: - Properties
    let hud = JGProgressHUD(style: .light)
    var activityIndicator: NVActivityIndicatorView?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var resetPassword: UIButton!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        // Do any additional setup after loading the view.
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
    func configureBackButton() {
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backAction))]
    }
    
    //MARK: - Selectors
    @IBAction func resetButtonDidTapped(_ sender: Any) {
//        print("DEBUG: Reset password")

        if emailTextField.text != "" {
            resetThePassword()
        } else {
            hud.textLabel.text = "Please insert E-mail!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper
    private func resetThePassword() {
        User.resetPasswordFor(email: emailTextField.text!) { (error) in
            
            if error == nil {
                self.hud.textLabel.text = "Reset password\nwas sent to email"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "")
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
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
