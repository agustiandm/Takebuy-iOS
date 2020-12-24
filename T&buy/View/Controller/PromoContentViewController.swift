//
//  PromoContentViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit

class PromoContentViewController: UIViewController {
    
    //MARK: - Properties
    var pageIndex = 0
    var imageName: String?
    
    @IBOutlet weak var promoImageView: UIImageView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentImage = imageName {
            promoImageView.image = UIImage(named: currentImage)
        }
        
        promoImageView.layer.cornerRadius = 10
        promoImageView.clipsToBounds = true
    }
}
