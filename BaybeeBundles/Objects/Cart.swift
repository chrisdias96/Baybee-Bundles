//
//  Cart.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-28.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit

class Cart {
    
    var cart: [CartItem] = []
    
    init() {
        
    }
    
    func addItemToCart(CartItem: CartItem) {
        cart.append(CartItem)
    }
    
}
