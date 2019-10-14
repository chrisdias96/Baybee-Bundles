//
//  Photo.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-14.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit

class Photo: NSObject {

    var image: UIImage
    var title: String
    var price: Double
    
    init(image: UIImage, title: String, price: Double) {
        self.image = image
        self.title = title
        self.price = price
    }
    
}
