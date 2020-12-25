//
//  Constants.swift
//  takebuy
//
//  Created by Agustian DM on 03/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import Foundation

enum Constats {
    static let publishableKey = "pk_test_51GvbJlB1NQ4smu3AdVdc4KI1YJV1BlrJJcRkTmocViQ1LiXRR44h5nLqKyK1RvTVkg8tcTEPVE7ng2D7jPUf8kFW00jyE7gd6l"
    static let baseURLString = "https://takebuyid.herokuapp.com/"  //"http://localhost:3000/"
    static let defaultCurrency = "usd"
    static let defaultDescription = "Purchase from Takebuy"
}

//ID & Key
public let FILEREFERENCE = "gs://takebuy-ios.appspot.com"
public let ALGOLIA_APP_ID = "7I6PS3DK7S"
public let ALGOLIA_SEARCH_KEY = "dda603b70af6e052967acc5743a501c3"
public let ALGOLIA_ADMIN_KEY = "b202a4ea69cfc2604fb044384619ec3a"

//Firebase Headers
public let USER_PATH = "User"
public let CATEGORY_PATH = "Category"
public let ITEMS_PATH = "Items"
public let BASKET_PATH = "Basket"

//Category
public let NAME = "name"
public let IMAGENAME = "imageName"
public let OBJECTID = "objectId"

//Item
public let CATEGORYID = "categoryId"
public let BRAND = "brand"
public let DESCRIPTION = "description"
public let PRICE = "price"
public let IMAGELINKS = "imageLinks"

//Cart
public let OWNERID = "ownerId"
public let ITEMIDS = "itemIds"

//User
public let EMAIL = "email"
public let FIRSTNAME  = "firstName"
public let LASTNAME  = "lastName"
public let FULLNAME  = "fullName"
public let CURRENTUSER  = "currentUser"
public let FULLADDRESS  = "fullAddress"
public let ONBOARD  = "onBoard"
public let PURCHASEDITEMIDS  = "purchasedItemIds"
