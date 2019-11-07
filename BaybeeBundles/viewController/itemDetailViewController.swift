//
//  itemDetailViewController.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-14.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit
import CoreData
import os.log

class itemDetailViewController: UIViewController {

    //MARK: Properties
    var db: DBHelper?
    var photo: Photo?
    var item: Item?
    var itemToPass: Item?
    
    var fetchedResultsController: NSFetchedResultsController<Item>!
    let customGrayColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    
    private let sizeDataSource = ["0-6 Months", "6-12 Months", "12-18 Months", "18-24 Months"]
    private let quantityDataSource = [1,2,3,4,5,6,7,8,9]
    
    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var valueOfSizeLabel: UILabel!
    @IBOutlet weak var sizePickerView: UIPickerView!
    @IBOutlet weak var valueOfQuantityLabel: UILabel!
    @IBOutlet weak var quantityPickerView: UIPickerView!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    //MARK: Actions
    @IBAction func addToCartAction(_ sender: UIStoryboardSegue) {
        //Grab all the values and return if a value is empty
        guard let title = self.title,
            !title.isEmpty,
            let image = photoImageView.image,
            //Convert UIImage to NSData
            let imageConvertedToNSData: Data = image.pngData(),
            let price = priceLabel.text,
            var size = valueOfSizeLabel.text,
            size != "",
            var quantity = valueOfQuantityLabel.text,
            !quantity.isEmpty else {
                return missingSizeOrQuantity()
        }
        
        var subtotal = 0.0
        subtotal = Double(price)! * Double(quantity)!
        
        //Otherwise, it's a new item, create it and add it
            db?.saveItem(title: title, price: Double(price)!, image: imageConvertedToNSData, size: size, quantity: Int64(quantity)!, subtotal: subtotal)
        size = ""
        quantity = ""
        
        
        #warning("Remove navigation controller")

    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sizePickerView.dataSource = self
        sizePickerView.delegate = self
        quantityPickerView.dataSource = self
        quantityPickerView.delegate = self
        
        // Get the Persistent Container if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        //Determine the size of the scrollview
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        //Grab the photo details of the item the user chose to view if it's new
        guard let item = self.photo else {
            //Grab the existing item if it exists
            guard let existingItem = self.itemToPass else {
                return
            }
            self.title = existingItem.title
            photoImageView.image = UIImage(data: existingItem.image!)
            priceLabel.text = String(existingItem.price)
            valueOfSizeLabel.text = existingItem.size
            valueOfQuantityLabel.text = String(existingItem.quantity)
            return
        }
        
        //Populate the view with the chosen collection item
        self.title = item.title
        photoImageView.image = item.image
        priceLabel.text = String(item.price)
        valueOfSizeLabel.text = sizeDataSource[0]
        valueOfQuantityLabel.text = String(quantityDataSource[0])
    }//end viewDidLoad

    //MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    //MARK: Functions
    
    /// This function displays an alert controller when the user attempts to add an item to their cart without choosing a size and/or quantity
    func missingSizeOrQuantity() {
        let alertController = UIAlertController(title: nil, message: "Please Choose a Size and Quantity", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    
    func addUIToButtons(button: UIButton) {
        button.layer.borderColor = customGrayColor.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
    }
    
    //MARK: objective c Methods
    @objc func buttonPressed(sender: UIButton) {
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 2
    }
   
}

//tag1: sizePickerView
//tag2: quantityPickerView
extension itemDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return sizeDataSource.count
        } else {
            return quantityDataSource.count
        }
    }
}

extension itemDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return sizeDataSource[row]
        } else {
            return "\(quantityDataSource[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            valueOfSizeLabel.text = sizeDataSource[row]
        } else {
            valueOfQuantityLabel.text = "\(quantityDataSource[row])"
        }
    }
}
