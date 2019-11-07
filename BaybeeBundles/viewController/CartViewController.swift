//
//  CartViewController.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-28.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UIViewController, CartTableViewCellProtocol {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    //MARK: Properties
    var items = [NSManagedObject]()
    var db: DBHelper?
    var persistentContainer: NSPersistentContainer!
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    var subtotal = 0.0

    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the Persistent Container if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        //Load the changes to the persistent container's moc
        NotificationCenter.default.addObserver(self, selector: #selector(self.managedObjectContextDidChange(notification:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)

        //Perform a fetchRequest
        guard let moc = db?.persistentContainer.viewContext else { fatalError("Cart not loaded - moc failed") }
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("Problem fetching results - \(error)")
        }

        subtotalLabel.text = String("$\(subtotal)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #warning("subtotal not adding correct price")
        //updateSubtotal()
    }
    
    func showDeleteConfirmationMessage(_ tappedCell: UITableViewCell, at indexPath: IndexPath) {
        
        let ac = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item from your cart?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(deleteAction)
        ac.addAction(cancelAction)
        
        //This is for devices with larger screens - Devices with larger screens present action sheets as popovers
        //Prevents from crashing bigger devices
        if let popOver = ac.popoverPresentationController {
            popOver.sourceView = tappedCell
            //Allows the delete cell to appear to the side instead of on top of the cell
            if let cell = tappedCell as? CartTableViewCell {
                let imageCenter = cell.cartImage.center
                popOver.sourceRect = CGRect(x: imageCenter.x, y: imageCenter.y, width: 0, height: 0)
            }
        }
        present(ac, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? "") {
            
        case "showItemFromCartSegue":
            guard let itemDetailVC = segue.destination as? itemDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedItemCell = sender as? CartTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            //        guard let indexPath = tableView.indexPathForSelectedRow
            //        else { return }
            
            let itemToPass = fetchedResultsController?.object(at: indexPath)
            itemDetailVC.itemToPass = itemToPass
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }

    }

}

//MARK: Extensions
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        cell.delegate = self
            
        let item = fetchedResultsController.object(at: indexPath)

        //Popuare the cell with it's items data
        cell.cartTitle.text = item.title
        cell.cartImage.image = UIImage(data: item.image!)
        cell.cartPrice.text = String(item.price)
        cell.cartSize.text = item.size
        cell.cartQuantity.text = ("\(Int64(item.quantity))")
        
        //Populate the UIStepper with it's tag and value
        cell.cartStepper.tag = indexPath.item
        cell.cartStepper.value = Double(item.quantity)
        
        //Style the cell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    #warning("fix updating subtotal")
//    func updateSubtotal() {
//
//        var total = 0.0
//
//        for item in db?.item {
//            total += item.price
//        }
//
//        subtotalLabel.text = String(total)
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let ac = UIAlertController(title: "Delete Item?", message: "Are you sure you want to delete this item from your cart?", preferredStyle: .actionSheet)
             let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                // Delete the row from the data source
                // use fetched results controller
                let itemToDelete = self.fetchedResultsController.object(at: indexPath)

                self.db?.persistentContainer.viewContext.delete(itemToDelete)
                do {
                    try self.db?.persistentContainer.viewContext.save()
                } catch let error {
                    print("We have an error when trying to delete - \(error.localizedDescription)")
                    self.db?.persistentContainer.viewContext.rollback()
                }
                 })
             let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
             ac.addAction(deleteAction)
             ac.addAction(cancelAction)
             
             present(ac, animated: true)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
}

//MARK: NSFetchedResultsControllerDelegate
extension CartViewController: NSFetchedResultsControllerDelegate {
    //When the controller is changing, we tell the tableview to update the changes
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    //Once the updates have been made and processed, end it
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //Receive a type parameter, which is NSFetchedResultsChangeType that contains info about the type of update received
        //The cases are the 4 types it can receive
        //Perform the following depending what type of update was received
        switch type {
        case .insert:
          guard let insertIndex = newIndexPath
            else { return }
          tableView.insertRows(at: [insertIndex], with: .automatic)
        case .delete:
          guard let deleteIndex = indexPath
            else { return }
          tableView.deleteRows(at: [deleteIndex], with: .automatic)
        case .move:
          guard let fromIndex = indexPath,
            let toIndex = newIndexPath
            else { return }
          tableView.moveRow(at: fromIndex, to: toIndex)
        case .update:
          guard let updateIndex = indexPath
            else { return }
          tableView.reloadRows(at: [updateIndex], with: .automatic)
        @unknown default:
            fatalError("controller error in CartViewController - NSFetchedResultsControllerDelegate")
        }
    }
}

//This extension has self respond to changes in the managed object context (moc)
extension CartViewController {
  @objc func managedObjectContextDidChange(notification: NSNotification) {
    //Check if there is userInfo changed
    guard let userInfo = notification.userInfo
      else { return }
    
    //Update the object on the table and reload it if theres a change
    if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<Item>,
        let item = self.db?.item,
      updatedObjects.contains(item) {
      
        tableView.reloadData()
    }
  }
}

//MARK: stepperTapped Protocol
#warning("Ask about screen flashing")
extension CartViewController {
    func stepperTapped(cell: CartTableViewCell) {
        //Grab the indexPath of the tableView
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }

        //Grab the associated item in the frc
        let item = fetchedResultsController.object(at: indexPath)
                
        //Grab the value of the UIstepper in the specific cell
        let stepperValue = Int(cell.cartStepper.value)
                
        //Change the text of quantity and item.quantity to the new value
        cell.cartQuantity.text = String(stepperValue)
        item.quantity = Int64(stepperValue)
        
        //Load the changes to the persistent container's moc
//        NotificationCenter.default.addObserver(self, selector: #selector(self.managedObjectContextDidChange(notification:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
    }
}
    
