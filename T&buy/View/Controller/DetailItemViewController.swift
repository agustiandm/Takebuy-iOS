//
//  DetailItemViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import JGProgressHUD

class DetailItemViewController: UIViewController {

    //MARK: - Properties
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .light)

    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let cellHeight: CGFloat = 413
    private let itemsPerRow: CGFloat = 1

    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadPicture()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
        
    //MARK: - Navigation
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "welcomeView")
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    func configureBackButton() {
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                                  style: .plain,
                                                                  target: self, action: #selector(self.backAction))]
    }

    
    //MARK: - Selectors
    @IBAction func addCartButtonDidTapped(_ sender: Any) {
        
        if User.currentUser() != nil {
            downloadCartFromFirestore(User.currentId()) { (cart) in
                if cart == nil {
                    self.createNewCart()
                }else{
                    cart!.itemIds.append(self.item.id)
                    self.updateCart(cart: cart!, withValues: [ITEMIDS : cart!.itemIds!])
                }
            }
        }else{
            showLoginView()
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper
    private func setupUI() {
        if item != nil {
            self.title = item.name
            brandLabel.text = item.brand
            nameLabel.text = item.name
            priceLabel.text = convertToCurrency(item.price)
            descriptionLabel.text = item.description
        }
        configureBackButton()
    }
    
    private func downloadPicture() {
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    //Add To Cart
    private func createNewCart() {
        let newCart = Cart()
        newCart.id = UUID().uuidString
        newCart.ownerId = User.currentId()
        newCart.itemIds = [self.item.id]
        saveCartToFirestore(newCart)
        
        self.hud.textLabel.text = "Success!"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func updateCart(cart: Cart, withValues: [String: Any]) {
        updateCartInFirestore(cart, withValues: withValues) { (error) in
            if error != nil {
                
                self.hud.textLabel.text = "\(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)

//                print("DEBUG: Error updating basket \(error!.localizedDescription)")
            } else {
                
                self.hud.textLabel.text = "Added to cart"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
}

extension DetailItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageDetailCell", for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.count > 0 {
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
        }
        return cell
    }
}

extension DetailItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - sectionInsets.left

        return CGSize(width: availableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
