//
//  SearchViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift

class SearchViewController: UIViewController {

    //MARK: - Properties
    var searchResults: [Item] = []
    var activityIndicator: NVActivityIndicatorView?
    
    @IBOutlet weak var searchOptionsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        showSearchField()
        
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        setupUI()
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
    private func showItemView(withItem: Item) {
        let detailItemVC = UIStoryboard.init(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "detailItemVC") as! DetailItemViewController
        detailItemVC.item = withItem
        self.navigationController?.pushViewController(detailItemVC, animated: true)
    }
    
    //MARK: - Selectors
//    @IBAction func showSearchBarbuttonDidTapped(_ sender: Any) {
//        dismissKeyboard()
//        showSearchField()
//    }
    
    @IBAction func searchButtonDidTapped(_ sender: Any) {
        if searchTextField.text != "" {
            
            searchInFirebase(forName: searchTextField.text!)
            emptyTextField()
//            animateSearchOptionsIn()
            dismissKeyboard()
        }
    }
    
    @objc func textFieldDidChange (_ textField: UITextField) {
        
        searchButton.isEnabled = textField.text != ""
        
        if searchButton.isEnabled {
            searchButton.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.1882352941, blue: 0.1333333333, alpha: 1)
        } else {
            disableSearchButton()
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    //MARK: - Search database

    private func searchInFirebase(forName: String) {
        
        showLoadingIndicator()
        searchAlgolia(searchString: forName) { (itemIds) in
            
            downloadItems(itemIds) { (allItems) in
                
                self.searchResults = allItems
                self.tableView.reloadData()
                
                self.hideLoadingIndicator()
            }
        }
    }
    
    
//    //MARK: - Animations
//    private func animateSearchOptionsIn() {
//        UIView.animate(withDuration: 0.5) {
//            self.searchOptionsView.isHidden = !self.searchOptionsView.isHidden
//            self.searchTextField.isHidden = !self.searchTextField.isHidden
//        }
//    }
    
    //MARK: - Helpers
    private func showSearchField() {
        disableSearchButton()
        emptyTextField()
//        animateSearchOptionsIn()
    }
    
    private func emptyTextField() {
        searchTextField.text = ""
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func disableSearchButton() {
        searchButton.isEnabled = false
        searchButton.backgroundColor = #colorLiteral(red: 0.8609231114, green: 0.235201031, blue: 0.1580969989, alpha: 1)
    }
    
    //MARK: - Activity indicator
    private func showLoadingIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }

    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    private func setupUI() {
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backAction))]

        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(searchResults[indexPath.row])
        
        return cell
        
    }
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: searchResults[indexPath.row])
    }
}

extension SearchViewController: EmptyDataSetSource, EmptyDataSetDelegate {
//    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//        return NSAttributedString(string: "Find your product...\n\n\n\n")
//    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "find")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "\nFind your product\n\n\n\n\n\n")
    }
}
