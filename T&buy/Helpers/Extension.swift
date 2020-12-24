//
//  Extension.swift
//  takebuy
//
//  Created by Agustian DM on 07/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    return currencyFormatter.string(from: NSNumber(value: number))!
}
