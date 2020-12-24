//
//  ItemsCollectionViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit

class ItemsCollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    var category: Category?
    var itemArray: [Item] = []

    private let sectionInsets = UIEdgeInsets(top: 15.0, left: 20.0, bottom: 15.0, right: 20.0)
    private let cellHeight: CGFloat = 290
    private let itemsPerRow: CGFloat = 2

    @IBOutlet weak var addItemButton: UIBarButtonItem!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if category != nil {
            loadItems()
        }
    }
            
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSeg" {
            
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
        }
    }
    
    private func showItemView(_ item: Item) {
        let detailItemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "detailItemVC") as! DetailItemViewController
        detailItemVC.item = item
        self.navigationController?.pushViewController(detailItemVC, animated: true)
    }
    
    
    
    //MARK: - Selectors
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Helpers
    //Load Items
    private func loadItems() {
        downloadItemsFromFirestore(category!.id) { (allItems) in
//            print("DEBUG: \(allItems.count)")
            self.itemArray = allItems
            self.collectionView.reloadData()
        }
    }
    
    func setupUI() {
        self.title = category?.name
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backAction))]
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if User.currentUser() != nil {
            addItemButton.isEnabled = true
        }else{
            addItemButton.isEnabled = false
            addItemButton.tintColor = .lightGray
        }
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ItemCollectionViewCell
        cell.generateCell(itemArray[indexPath.row])
    
        return cell
    }
}

extension ItemsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let withPerItem = availableWidth / itemsPerRow

        return CGSize(width: withPerItem, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

