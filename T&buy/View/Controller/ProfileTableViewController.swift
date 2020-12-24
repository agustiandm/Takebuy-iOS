//
//  ProfileTableViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK: - Properties
    var editBarButton: UIBarButtonItem!
    var user: User!
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var finishSignupButton: UIButton!
    @IBOutlet weak var orderHistoryButton: UIButton!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkOnboardingStatus()
        checkLoginStatus()
    }
    
    //MARK: - Navigation
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "welcomeView")
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    private func goToEditProfile() {
        performSegue(withIdentifier: "profileToEditSeg", sender: self)
    }
    
    //MARK: - Selectors
    @objc func rightBarButtonItemPressed() {
        
        if editBarButton.title == "Login" {
            showLoginView()
        } else {
            goToEditProfile()
        }
    }
    
    //MARK: - Helpers
    private func userInfo() {
        fullnameLabel.text = User.currentUser()?.fullName
        emailLabel.text = User.currentUser()?.email
    }
    
    private func checkOnboardingStatus() {
        if User.currentUser() != nil {
            
            if User.currentUser()!.onBoard {
                userInfo()
                finishSignupButton.setTitle("Account is Active", for: .normal)
                finishSignupButton.isEnabled = false
            } else {
                fullnameLabel.text = "Yourname"
                emailLabel.text = "E-mail"
                finishSignupButton.setTitle("Finish registration", for: .normal)
                finishSignupButton.isEnabled = true
                finishSignupButton.tintColor = .red
            }
            
            orderHistoryButton.isEnabled = true
            
        } else {
            fullnameLabel.text = "Yourname"
            emailLabel.text = "E-mail"
            finishSignupButton.setTitle("Sign out", for: .normal)
            finishSignupButton.isEnabled = false
            orderHistoryButton.isEnabled = false
        }
    }
    
    private func checkLoginStatus() {
        
        if User.currentUser() == nil {
            createRightBarButton(title: "Login")
        } else {
            createRightBarButton(title: "Edit")
        }
    }
    
    private func createRightBarButton(title: String) {
        
        editBarButton = UIBarButtonItem(title: title,
                                        style: .plain,
                                        target: self,
                                        action: #selector(rightBarButtonItemPressed))
        
        self.navigationItem.rightBarButtonItem = editBarButton
    }
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}
