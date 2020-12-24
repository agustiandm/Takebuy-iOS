//
//  ItemTableViewCell.swift
//  T&buy
//
//  Created by Agustian DM on 08/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    
    //MARK: - Properties
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Helper
    func generateCell(_ item: Item) {
        brandLabel.text = item.brand
        nameLabel.text = item.name
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
