//
//  AddItemViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    var category: Category!
    var itemImages: [UIImage?] = []
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .light)
    var activityIndicator: NVActivityIndicatorView?
    
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var nameProductTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var brandContainerView: UIView!
    @IBOutlet weak var nameProductContainer: UIView!
    @IBOutlet weak var priceContainerView: UIView!
    @IBOutlet weak var descriptionContainerView: UIView!
    @IBOutlet weak var addImageContainer: UIView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("DEBUG: \(category.id)")
        configureUI()
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
    
    //MARK: - Selectors
    @IBAction func addImageButtonDidTapped(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    
    @IBAction func doneButtonDidTapped(_ sender: Any) {
        dismissKeayboard()
        
        if fieldsAreCompleted() {
            saveToFirebase()
        } else {
            self.hud.textLabel.text = "Field required!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func backgroundDidTapped(_ sender: Any) {
        dismissKeayboard()
    }
    
    
    //MARK: - Helper
    
    //Save Item to Firebsae
    private func saveToFirebase() {
        
        showLoadingIndicator()
        
        let item = Item()
        item.id = UUID().uuidString
        item.name = nameProductTextField.text!
        item.brand = brandTextField.text!
        item.categoryId = category.id
        item.description = descriptionTextView.text
        item.price = Double(priceTextField.text!)
        
        if itemImages.count > 0 {
            
            uploadImages(images: itemImages, itemId: item.id) { (imageLikArray) in
                
                item.imageLinks = imageLikArray
                
                saveItemToFirestore(item)
                saveItemToAlgolia(item: item)
                
                self.hideLoadingIndicator()
                self.popTheView()
            }
            
        } else {
            saveItemToFirestore(item)
            saveItemToAlgolia(item: item)
            popTheView()
        }
    }
    
    //Show Gallery
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
    }
    
    private func fieldsAreCompleted() -> Bool {
        return (brandTextField.text != "" && nameProductTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    }
    
    private func dismissKeayboard() {
        self.view.endEditing(false)
    }
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    func configureUI() {
        brandContainerView.layer.cornerRadius = 5
        brandContainerView.layer.borderWidth = 0.5
        brandContainerView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        brandContainerView.clipsToBounds = true
        
        nameProductContainer.layer.cornerRadius = 5
        nameProductContainer.layer.borderWidth = 0.5
        nameProductContainer.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        nameProductContainer.clipsToBounds = true
        
        priceContainerView.layer.cornerRadius = 5
        priceContainerView.layer.borderWidth = 0.5
        priceContainerView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        priceContainerView.clipsToBounds = true
        
        descriptionContainerView.layer.cornerRadius = 5
        descriptionContainerView.layer.borderWidth = 0.5
        descriptionContainerView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        descriptionContainerView.clipsToBounds = true
        
        addImageContainer.layer.cornerRadius = 5
        addImageContainer.layer.borderWidth = 0.5
        addImageContainer.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        addImageContainer.clipsToBounds = true
        
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.delegate = self
    }
}

extension AddItemViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
