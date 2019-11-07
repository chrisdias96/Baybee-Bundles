//
//  Cart.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-28.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import CoreData

//This extension queries Core Data for an existing item title
extension Item {
    static func find(byTitle title: String, orCreateIn moc: NSManagedObjectContext) -> Item {
        let predicate = NSPredicate(format: "title ==[dc] %@", title)
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = predicate
        
        //Check if a movie is found, if not create it
        guard let result = try? moc.fetch(request)
            else { return Item(context: moc) }
        
        return result.first ?? Item(context: moc)
    }
    
}
