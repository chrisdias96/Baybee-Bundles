//
//  itemDetailViewController.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-14.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit

class itemDetailViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //Outlets for size related buttons
    @IBOutlet weak var valueOfSizeLabel: UILabel!
    @IBOutlet weak var zeroToSixMonthsButton: UIButton!
    @IBOutlet weak var sixToTwelveMonthsButton: UIButton!
    @IBOutlet weak var twelveToEighteenMonthsButton: UIButton!
    @IBOutlet weak var eighteenToTwentyFourMonthsButton: UIButton!
    
    //Outlets for quantity related buttons
    @IBOutlet weak var valueOfQuantityLabel: UILabel!
    @IBOutlet weak var oneQuantityButton: UIButton!
    @IBOutlet weak var twoQuantityButton: UIButton!
    @IBOutlet weak var threeQuantityButton: UIButton!
    @IBOutlet weak var fourQuantityButton: UIButton!
    @IBOutlet weak var fiveQuantityButton: UIButton!
    @IBOutlet weak var sixQuantityButton: UIButton!
    @IBOutlet weak var sevenQuantityButton: UIButton!
    @IBOutlet weak var eightQuantityButton: UIButton!
    @IBOutlet weak var nineQuantityButton: UIButton!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    //MARK: Actions
    @IBAction func zeroToSixMonthsButton(_ sender: Any) {
        valueOfSizeLabel.text = zeroToSixMonthsButton.currentTitle
        addBorderToSizeButtons()
        buttonPressed(sender: zeroToSixMonthsButton)
        
    }
    @IBAction func sixToTwelveMonthsButton(_ sender: Any) {
        valueOfSizeLabel.text = sixToTwelveMonthsButton.currentTitle
        addBorderToSizeButtons()
        buttonPressed(sender: sixToTwelveMonthsButton)
    }
    @IBAction func twelveToEighteenMonthsButton(_ sender: Any) {
        valueOfSizeLabel.text = twelveToEighteenMonthsButton.currentTitle
        addBorderToSizeButtons()
        buttonPressed(sender: twelveToEighteenMonthsButton)
    }
    @IBAction func eighteenToTwentyFourMonthsButton(_ sender: Any) {
        valueOfSizeLabel.text = eighteenToTwentyFourMonthsButton.currentTitle
        addBorderToSizeButtons()
        buttonPressed(sender: eighteenToTwentyFourMonthsButton)
    }
    @IBAction func oneQuantityButton(_ sender: Any) {
        valueOfQuantityLabel.text = oneQuantityButton.currentTitle
        addBorderToQuantityButtons()
        buttonPressed(sender: oneQuantityButton)
    }
    @IBAction func twoQuantityButton(_ sender: Any) {
        valueOfQuantityLabel.text = twoQuantityButton.currentTitle
        addBorderToQuantityButtons()
        buttonPressed(sender: twoQuantityButton)
    }
    @IBAction func threeQuantityButton(_ sender: Any) {
        valueOfQuantityLabel.text = threeQuantityButton.currentTitle
        addBorderToQuantityButtons()
        buttonPressed(sender: threeQuantityButton)
    }
    @IBAction func fourQuantityButton(_ sender: Any) {
        valueOfQuantityLabel.text = fourQuantityButton.currentTitle
        addBorderToQuantityButtons()
        buttonPressed(sender: fourQuantityButton)
    }
    @IBAction func fiveQuantityButton(_ sender: Any) {
        valueOfQuantityLabel.text = fiveQuantityButton.currentTitle
        addBorderToQuantityButtons()
        buttonPressed(sender: fiveQuantityButton)
    }
    @IBAction func sixQuantityButton(_ sender: Any) {
        valueOfQuantityLabel.text = sixQuantityButton.currentTitle
        addBorderToQuantityButtons()
        buttonPressed(sender: sixQuantityButton)
    }
    @IBAction func sevenQuantityButton(_ sender: Any) {
        valueOfQuantityLabel.text = sevenQuantityButton.currentTitle
        addBorderToQuantityButtons()
        buttonPressed(sender: sevenQuantityButton)
    }
    @IBAction func eightQuantityButton(_ sender: Any) {
        valueOfQuantityLabel.text = eightQuantityButton.currentTitle
        addBorderToQuantityButtons()
        buttonPressed(sender: eightQuantityButton)
    }
    @IBAction func nineQuantityButton(_ sender: Any) {
        valueOfQuantityLabel.text = nineQuantityButton.currentTitle
        addBorderToQuantityButtons()
        buttonPressed(sender: nineQuantityButton)
    }
    @IBAction func addToCartAction(_ sender: Any) {
        //Grab the values of size and quantity
        //Check if they are not
       
        guard let valueOfSize = valueOfSizeLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let valueOfQuantity = valueOfQuantityLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !valueOfSize.isEmpty, !valueOfQuantity.isEmpty else {
                print("value of size or quantity is empty")
                return
        }
        
//        guard let item = self.photo else {
//            return
//        }
//
//        photoImageView.image = item.image
//        titleLabel.text = "\(item.title)"
//        priceLabel.text = "$\(item.price)"
        
        
        let item = CartItem(image: photoImageView.image!,
                            title: self.title!,
                            totalPrice: Double(priceLabel.text!)!,
                            size: valueOfSize,
                            quantity: Int(valueOfQuantity)!)
        
        //Add the items to the Cart struct
        cart.addItemToCart(CartItem: item)
        
        #warning("Determine why tableview is not reloading")
        print(item)
        print(cart.cart.count)
        
    }
    
    //MARK: Properties
    var photo: Photo?
    var cart = Cart()
    let customGrayColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBorderToQuantityButtons()
        addBorderToSizeButtons()

        //Determine the size of the scrollview
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        //Grab the photo details of the item the user chose to view
        guard let item = self.photo else {
            return
        }
        
        //Set the title of the nav bar to the item
        self.title = item.title
        
        //Populate the view with the chosen collection item
        photoImageView.image = item.image
//        titleLabel.text = "\(item.title)"
        priceLabel.text = String(item.price)
        
    }//end viewDidLoad

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func addBorderToQuantityButtons() {
        addUIToButtons(button: oneQuantityButton)
        addUIToButtons(button: twoQuantityButton)
        addUIToButtons(button: threeQuantityButton)
        addUIToButtons(button: fourQuantityButton)
        addUIToButtons(button: fiveQuantityButton)
        addUIToButtons(button: sixQuantityButton)
        addUIToButtons(button: sevenQuantityButton)
        addUIToButtons(button: eightQuantityButton)
        addUIToButtons(button: nineQuantityButton)
    }
    
    func addBorderToSizeButtons() {
        addUIToButtons(button: zeroToSixMonthsButton)
        addUIToButtons(button: sixToTwelveMonthsButton)
        addUIToButtons(button: twelveToEighteenMonthsButton)
        addUIToButtons(button: eighteenToTwentyFourMonthsButton)
    }
    
    func addUIToButtons(button: UIButton) {
        button.layer.borderColor = customGrayColor.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
    }
    
    @objc func buttonPressed(sender: UIButton) {
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 2
        
    }
    
}
