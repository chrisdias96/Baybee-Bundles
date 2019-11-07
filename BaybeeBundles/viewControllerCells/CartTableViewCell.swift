//
//  CartTableViewCell.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-28.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartTitle: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
    @IBOutlet weak var cartSize: UILabel!
    @IBOutlet weak var cartQuantity: UILabel!
    @IBOutlet weak var editCellLabel: UILabel!
    @IBOutlet weak var cartStepper: UIStepper!
    
    weak var delegate: CartTableViewCellProtocol?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @IBAction func stepperAction(sender: UIStepper) {
        self.delegate?.stepperTapped(cell: self)
    }
    
}

protocol CartTableViewCellProtocol: class {
    func stepperTapped(cell: CartTableViewCell)
}
