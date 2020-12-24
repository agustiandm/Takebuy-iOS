//
//  CategoryCollectionViewCell.swift
//  T&buy
//
//  Created by Agustian DM on 03/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryContainerView: UIView!

    func generateCell(_ category: Category) {
        imageView.image = category.image
        nameLabel.text = category.name
        setupUI()
    }
    
    private func setupUI() {
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        categoryContainerView.layer.cornerRadius = 10
        categoryContainerView.clipsToBounds = true

    }
}
