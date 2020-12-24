//
//  CartViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import JGProgressHUD
import EmptyDataSet_Swift
import Stripe

class CartViewController: UIViewController {
    
    //MARK: - Properties
    var cart: Cart?
    var allItems: [Item] = []
    var purchasedItemIds: [String] = []
    var totalPrice = 0
    let hud = JGProgressHUD(style: .light)
    
    @IBOutlet weak var totalItemLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var totalItemContainerView: UIView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if User.currentUser() != nil {
            loadCartFromFirestore()
        }else{
            self.updateTotalLabels(true)
        }
    }
    
    //MARK: - Navigation
    private func showItemView(withItem: Item) {
        
        let detailItemVC = UIStoryboard.init(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "detailItemVC") as! DetailItemViewController
        detailItemVC.item = withItem
        self.navigationController?.pushViewController(detailItemVC, animated: true)
    }
        
    //MARK: - Selectors
    @IBAction func checkoutButtonDidTapped(_ sender: Any) {
        if User.currentUser()!.onBoard {
            showPaymentOptins()
        } else {
            self.showNotification(text: "Please complete your profile!", isError: true)
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper
    //Download cart
    private func loadCartFromFirestore() {
        downloadCartFromFirestore(User.currentId()) { (cart) in
            self.cart = cart
            self.getCartItems()
        }
    }
    
    private func getCartItems() {
        if cart != nil {
            downloadItems(cart!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
        }
    }
    
    private func updateTotalLabels(_ isEmpty: Bool) {
        
        if isEmpty {
            totalItemLabel.text = "0"
            totalPriceLabel.text = returnCartTotalPrice()
        } else {
            totalItemLabel.text = "\(allItems.count)"
            totalPriceLabel.text = returnCartTotalPrice()
        }
        
        checkoutButtonStatusUpdate()
    }
    
    private func returnCartTotalPrice() -> String {
        
        var totalPrice = 0.0
        
        for item in allItems {
            totalPrice += item.price
        }
        return convertToCurrency(totalPrice)
    }
    
    private func removeItemFromCart(itemId: String) {
        for i in 0..<cart!.itemIds.count {
            
            if itemId == cart!.itemIds[i] {
                cart!.itemIds.remove(at: i)
                
                return
            }
        }
    }
    
    private func emptyTheCart() {
        
        purchasedItemIds.removeAll()
        allItems.removeAll()
        tableView.reloadData()
        
        cart!.itemIds = []
        
        updateCartInFirestore(cart!, withValues: [ITEMIDS : cart!.itemIds!]) { (error) in
            
            if error != nil {
//                print("DEBUG: Error updating basket ", error!.localizedDescription)
            }
            
            self.getCartItems()
        }
    }
    
    private func addItemsToPurchaseHistory(_ itemIds: [String]) {
        
        if User.currentUser() != nil {
            
//            print("DEBUG: item ids, ", itemIds)
            let newItemIds = User.currentUser()!.purchasedItemIds + itemIds
            
            updateCurrentUserInFirestore(withValues: [PURCHASEDITEMIDS: newItemIds]) { (error) in
                
                if error != nil {
//                    print("DEBUG: Error adding purchased items ", error!.localizedDescription)
                }
            }
        }
    }
    
    //stripe
    private func finishPayment(token: STPToken) {
        
        self.totalPrice = 0
        
        for item in allItems {
            purchasedItemIds.append(item.id)
            self.totalPrice += Int(item.price)
        }
        
        self.totalPrice = self.totalPrice * 100
        
        StripeClient.sharedClient.createAndConfirmPayment(token, amount: totalPrice) { (error) in
            
            if error == nil {
                self.addItemsToPurchaseHistory(self.purchasedItemIds)
                self.emptyTheCart()
                self.showNotification(text: "Payment Success!", isError: false)
            } else {
                self.showNotification(text: error!.localizedDescription, isError: true)
//                print("DEBUG: error ", error!.localizedDescription)
            }
        }
    }
    
    private func showNotification(text: String, isError: Bool) {
        
        if isError {
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func showPaymentOptins() {
        
        let alertController = UIAlertController(title: "Payment Options", message: "Choose prefered payment option", preferredStyle: .actionSheet)
        
        let cardAction = UIAlertAction(title: "Pay with Card", style: .default) { (action) in
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "cardInfoVC") as! CardInfoViewController
            
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func checkoutButtonStatusUpdate() {
        
        checkOutButton.isEnabled = allItems.count > 0
        
        if checkOutButton.isEnabled {
            checkOutButton.backgroundColor = .white
        } else {
            disableCheoutButton()
        }
    }

    private func disableCheoutButton() {
        checkOutButton.isEnabled = false
        checkOutButton.backgroundColor = .white
    }
    
    private func setupUI() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
//        totalItemContainerView.layer.borderWidth = 0.5
//        totalItemContainerView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        totalItemContainerView.layer.cornerRadius = 7
        totalItemContainerView.clipsToBounds = true
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(allItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = allItems[indexPath.row]
            
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromCart(itemId: itemToDelete.id)
            updateCartInFirestore(cart!, withValues: [ITEMIDS: cart!.itemIds!]) { (error) in
                
                if error != nil {
//                    print("DEBUG: error updating the basket \(error!.localizedDescription)")
                }
                self.getCartItems()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
}

extension CartViewController: CardInfoViewControllerDelegate {
    
    func didClickDone(_ token: STPToken) {
        finishPayment(token: token)
    }
    
    func didClickCancel() {
        showNotification(text: "Payment Canceled", isError: true)
    }
}

extension CartViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Take your product")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "cartEmpty")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Buy now!!!\n\n")
    }
}
