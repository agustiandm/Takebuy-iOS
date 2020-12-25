//
//  Category.swift
//  T&buy
//
//  Created by Agustian DM on 03/08/20.
//

import Foundation
import UIKit

class Category {
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name: String, _imageName: String) {
        
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[OBJECTID] as! String
        name = _dictionary[NAME] as! String
        image = UIImage(named: _dictionary[IMAGENAME] as? String ?? "")
    }
}


//MARK: Save category function

func saveCategoryToFirebase(_ category: Category) {
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseRef(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
}

//MARK: Helpers

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id,
                                  category.name,
                                  category.imageName!],
                        forKeys: [OBJECTID as NSCopying,
                                  NAME as NSCopying,
                                  IMAGENAME as NSCopying])
}

//MARK: Download category from firebase

func downloadCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void) {
    
    var categoryArray: [Category] = []
    
    FirebaseRef(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
        }
        
        completion(categoryArray)
    }
}

//use only one time
//func createCategorySet() {
//
//    let cj = Category(_name: "Jacket", _imageName: "cj")
//    let ct = Category(_name: "T-shirt", _imageName: "ct")
//   let cs = Category(_name: "Shoes", _imageName: "cs")
//    let ca = Category(_name: "Accessories" , _imageName: "ca")
//
//    let arrayOfCategories = [cs, ca]
//
//    for category in arrayOfCategories {
//        saveCategoryToFirebase(category)
//    }
//}
