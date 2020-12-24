//
//  OrderHistoryTableViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class OrderHistoryTableViewController: UITableViewController {

    //MARK: - Properties
    var itemArray: [Item] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
    }
    
    //MARK: -Selectors
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper
    private func loadItems() {
        downloadItems(User.currentUser()!.purchasedItemIds) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
    
    func configureBackButton() {
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(self.backAction))]
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(itemArray[indexPath.row])
        
        return cell
    }
}

extension OrderHistoryTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No transactions")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "empty")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Buy now!\n\n\n\n\n\n\n\n\n\n\n\n")
    }
}
