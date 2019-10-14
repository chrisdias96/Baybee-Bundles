//
//  ShopViewController.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-14.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    //MARK: Properties
    var categories: [Category] = [
        Category(image: UIImage(named: "hat1")!, title: "HATS"),
        Category(image: UIImage(named: "headband1")!, title: "HEADBANDS"),
        Category(image: UIImage(named: "gloves1")!, title: "GLOVES"),
        Category(image: UIImage(named: "socks1")!, title: "SOCKS"),
    ]
    
    //Declare all 4 - separate categories
//    var hatPhotos: Hats!
//    var headbandPhotos: Headbands!
//    var glovePhotos: Gloves!
//    var sockPhotos: Socks!
//
//    let categorySegueIdentifier = "showCategoryItemsSegue"
//    var photoTitleToPass = String()
//    var photoImageToPass: UIImage
//    var photoPriceToPass = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

    }
    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
////        if segue.identifier == categorySegueIdentifier,
////            let destination = segue.destination as? ShopViewController,
////            let categoryIndex = tableView.indexPathForSelectedRow?.row {
////            destination.categoryToPass = currentCell
////        }
//
//        if segue.destination is CategoryCollectionViewController {
//            let vc = segue.destination as? CategoryCollectionViewController
//            vc?.categoryViewToPass = tableView.cellForRow(at: IndexPath) as! CategoryTableViewCell
//        }
//    }
    

}

//MARK: Extensions
extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
            
        let category = categories[indexPath.row]
            
        cell.catImage.image = category.image
        cell.catTitle.text = category.title
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellSpacingHeight: CGFloat = 100
        
        return cellSpacingHeight
    }
    
    #warning("Pass photo arrays depending on which category is clicked from the tableview")
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let indexPath = tableView.indexPathForSelectedRow!
//        let currentCell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
//
//        switch indexPath.row {
//        case 0:
//            photoTitleToPass = currentCell.catTitle
//        default:
//
//        }
//        photoTitleToPass = currentCell.photoTitle.text
//        photoImageToPass = currentCell.
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryCollectionViewController") as? CategoryCollectionViewController
//
//        vc.catImage.image = category.image
//
//        self.navigationController?.pushViewController(vc!, animated: true)
//    }
    
    
}
