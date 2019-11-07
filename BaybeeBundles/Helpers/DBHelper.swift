//
//  dbHelper.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-11-01.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit
import CoreData

class DBHelper {
    
    //MARK: Properties
    var persistentContainer: NSPersistentContainer!
    var item: Item?
    
    //MARK: saveItem
    func saveItem(title: String, price: Double, image: Data, size: String, quantity: Int64, subtotal: Double) {
        
        let moc = self.persistentContainer.viewContext
        
        //If item already exists, update it in the cart
        moc.persist {
            if let item = self.item {
                item.title = title
                item.image = image
                item.price = price
                item.size = size
                item.quantity = quantity
                item.subtotal = price * Double(quantity)
            } else {
                //Create a new item in the cart
                let newItem = Item(context: moc)
                newItem.title = title
                newItem.image = image
                newItem.price = price
                newItem.size = size
                newItem.quantity = quantity
                newItem.subtotal = price * Double(quantity)
            }
        }
    }
    
}

extension NSManagedObjectContext {
    func persist(block: @escaping () -> Void) {
        perform {
            block()
            
            do {
                try self.save()
            } catch {
                self.rollback()
            }
        }
    }
}
