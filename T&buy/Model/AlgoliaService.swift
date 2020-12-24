//
//  AlgoliaService.swift
//  T&buy
//
//  Created by Agustian DM on 11/08/20.
//

import Foundation
import InstantSearchClient

class AlgoliaService {

    static let shared = AlgoliaService()
    
    let client = Client(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_ADMIN_KEY)
    let index = Client(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_ADMIN_KEY).index(withName: "item_Name")
    
    private init() {}
}
