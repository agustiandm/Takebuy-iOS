//
//  Ref.swift
//  takebuy
//
//  Created by Agustian DM on 03/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FirebaseCollectionRef: String {
    case User
    case Category
    case Items
    case Cart
}

func FirebaseRef(_ collectionReference: FirebaseCollectionRef) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
