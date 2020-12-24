//
//  ImageCollectionViewCell.swift
//  T&buy
//
//  Created by Agustian DM on 07/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        imageView.image = itemImage
        setupUI()
    }
    
    func setupUI() {
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
}
