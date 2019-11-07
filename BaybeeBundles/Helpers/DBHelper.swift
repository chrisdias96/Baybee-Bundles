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
    var fetchedResultsController: NSFetchedResultsController<Item>!
    var item: Item?
    
    //MARK: saveItem
    func saveItem(title: String, price: Double, image: Data, size: String, quantity: Int64, subtotal: Double) {
        
        let moc = self.persistentContainer.viewContext

        moc.persist {
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
    
    func updateItem(title: String, price: Double, image: Data, size: String, quantity: Int64, subtotal: Double) {
        
        let moc = self.persistentContainer.viewContext
        
        //Get all the items in the cart and add it to an array
        let itemArray = self.getAllItems()
        
        //This is a flag to determine if an item that was to be added into the cart already exists
        var didItemMatch = false
        
        moc.persist {
            //Iterate through each item to find out of the item to be added already exists
            for item in itemArray {
                //If item already exists, update it in the cart
                if title == item.title,
                    size == item.size {
                    var quantityToReturn: Int64
                    quantityToReturn = item.quantity + quantity
                    print("item matched: adding to quantity")
                    item.quantity = quantityToReturn
                    //Switch the flag
                    didItemMatch = true
                }
            }
            //If no match was found, add it to the cart
            if didItemMatch == false {
                self.saveItem(title: title, price: price, image: image, size: size, quantity: quantity, subtotal: subtotal)
                print("saving item from within updateItem")
            }
        }
        
    }
    
    func createTempItem(title: String, price: Double, image: Data, size: String, quantity: Int64, subtotal: Double) -> Item {
        
        //Create a new temporary item to be used to determine if it should be added into the cart as a new item or if it already exists
        let tempItem = Item()
        tempItem.title = title
        tempItem.image = image
        tempItem.price = price
        tempItem.size = size
        tempItem.quantity = quantity
        tempItem.subtotal = price * Double(quantity)
        
        print("Create tempItem")
        
        return tempItem
    }
    
    func getAllItems() -> [Item] {
        // Get the database and create a request
        let moc = self.persistentContainer.viewContext
        var items = [NSManagedObject]()
        
        let itemRequest = NSFetchRequest<Item>(entityName: "Item")
        
        itemRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            items = try moc.fetch(itemRequest)
        } catch {
            fatalError("Could not load items")
        }
        print("Fetched \(items.count) items")
        return items as! [Item]
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

extension DBHelper {
    // MARK: - Core Data Saving support
    func save() {
        
        let moc = self.persistentContainer.viewContext
        do {
            try moc.save()
        } catch let error {
            fatalError("Unresolved error when saving - \(error.localizedDescription)")
        }
    }
}
