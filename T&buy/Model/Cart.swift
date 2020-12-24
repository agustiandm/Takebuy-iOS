//
//  Cart.swift
//  T&buy
//
//  Created by Agustian DM on 08/08/20.
//

import Foundation

class Cart {
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[OBJECTID] as? String
        ownerId = _dictionary[OWNERID] as? String
        itemIds = _dictionary[ITEMIDS] as? [String]
    }
}

//MARK: - Save To Firebase
func saveCartToFirestore(_ cart: Cart) {
    FirebaseRef(.Cart).document(cart.id).setData(cartDictionaryFrom(cart) as! [String: Any])
}

//MARK: - Download Cart From Firebase
func downloadCartFromFirestore(_ ownerId: String, completion: @escaping (_ cart: Cart?) -> Void) {
    
    FirebaseRef(.Cart).whereField(OWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let cart = Cart(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(cart)
        }else{
            completion(nil)
        }
    }
}

//MARK: - Update Cart
func updateCartInFirestore(_ cart: Cart, withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
    FirebaseRef(.Cart).document(cart.id).updateData(withValues) { (error) in
        completion(error)
    }
}

//MARK: - Helper functions
func cartDictionaryFrom(_ cart: Cart) -> NSDictionary {
    
    return NSDictionary(objects: [cart.id!,
                                  cart.ownerId!,
                                  cart.itemIds!],
                        forKeys: [OBJECTID as NSCopying,
                                  OWNERID as NSCopying,
                                  ITEMIDS as NSCopying])
}
