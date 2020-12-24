//
//  ItemCollectionViewCell.swift
//  T&buy
//
//  Created by Agustian DM on 04/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK: - Lifecycle
    
    
    //MARK: - Helper
    func generateCell(_ item: Item) {
        brandLabel.text = item.brand
        nameProductLabel.text = item.name
        priceLabel.text = convertToCurrency(item.price)
        priceLabel.adjustsFontSizeToFitWidth = true
        setupUI()
        
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            downloadImages(imageUrls: [item.imageLinks.first!]) { (images) in
                self.itemImageView.image = images.first as? UIImage
            }
        }
    }
    
    private func setupUI() {
        itemImageView.layer.cornerRadius = 10
        itemImageView.clipsToBounds = true
    }
}
