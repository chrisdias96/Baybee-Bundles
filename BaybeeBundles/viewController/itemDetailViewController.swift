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
    @IBOutlet weak var valueOfSizeTextField: UITextField!
    @IBOutlet weak var valueOfQuantityTextField: UITextField!
    
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    //MARK: Actions
    @IBAction func addToCartAction(_ sender: UIStoryboardSegue) {
        //Grab all the values and return if a value is empty
        guard let title = self.title,
            !title.isEmpty,
            let image = photoImageView.image,
            //Convert UIImage to NSData
            let imageConvertedToNSData: Data = image.pngData(),
            var price = priceLabel.text,
            let size = valueOfSizeTextField.text,
            size != "",
            let quantity = valueOfQuantityTextField.text,
            !quantity.isEmpty else {
                return missingSizeOrQuantity()
        }
        //Add to subtotal
        price.remove(at: price.startIndex)
        var subtotal = 0.0
        subtotal = Double(price)! * Double(quantity)!
        
        if db?.getAllItems().count != 0 {
            db?.updateItem(title: title, price: Double(price)!, image: imageConvertedToNSData, size: size, quantity: Int64(quantity)!, subtotal: subtotal)
        } else {
            db?.saveItem(title: title, price: Double(price)!, image: imageConvertedToNSData, size: size, quantity: Int64(quantity)!, subtotal: subtotal)
            print("saving new item from else statement")
        }

        showToast(message: "Added to Cart")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the Persistent Container if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        //Determine the size of the scrollview
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)

        //Call the UIPickers
        createSizePicker()
        createQuantityPicker()
        CreateToolBar()
        
        //Grab the photo details of the item the user chose to view if it's new
        guard let item = self.photo else {
            return
        }
        
        //Populate the view with the chosen collection item
        self.title = item.title
        photoImageView.image = item.image
        priceLabel.text = "$\(item.price)"
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
    
    func createSizePicker() {
        let sizePicker = UIPickerView()
        sizePicker.delegate = self
        
        valueOfSizeTextField.inputView = sizePicker
    }
    
    func createQuantityPicker() {
        let quantityPicker = UIPickerView()
        quantityPicker.delegate = self
        
        valueOfQuantityTextField.inputView = quantityPicker
    }
    
    func CreateToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        valueOfSizeTextField.inputAccessoryView = toolBar
        valueOfQuantityTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Objective-C Methods
    @objc func buttonPressed(sender: UIButton) {
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 2
    }
}//end Class

extension itemDetailViewController {
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2, width: 150, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Chalkboard SE Regular", size: 13)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0,  animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

//MARK: UITextFieldDelegate
//extension itemDetailViewController: UITextFieldDelegate {
//    var activeTextField = UITextField()
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.activeTextField =
//    }
//}

//MARK: UIPickerViewDataSource
//tag1: sizePickerView
//tag2: quantityPickerView
extension itemDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if valueOfSizeTextField.isFirstResponder {
            return sizeDataSource.count
        } else {
            return quantityDataSource.count
        }
    }
}

//MARK: UIPickerViewDelegate
extension itemDetailViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if valueOfSizeTextField.isFirstResponder {
            return sizeDataSource[row]
        }
        if valueOfQuantityTextField.isFirstResponder {
            return String(quantityDataSource[row])
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if valueOfSizeTextField.isFirstResponder {
            valueOfSizeTextField.text = sizeDataSource[row]
        }
        if valueOfQuantityTextField.isFirstResponder {
            valueOfQuantityTextField.text = String(quantityDataSource[row])
        }
        return
    }
}
