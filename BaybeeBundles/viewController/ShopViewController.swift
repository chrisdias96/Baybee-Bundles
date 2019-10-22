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
    var categories = Categories()
    var passedCategories: String!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let selectedIndex = tableView.indexPathForSelectedRow
            else { return }
        
        //let category = categories.categories[selectedIndex.row]
        let category = categories.categories[selectedIndex.row]
        let title = category.title
        
        if let categoryCollectionVC = segue.destination as? CategoryCollectionViewController {
            categoryCollectionVC.category = title
        }

    }

}//end Class

//MARK: Extensions
extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
            
        let category = categories.categories[indexPath.row]
            
        cell.catImage.image = category.image
        cell.catTitle.text = category.title
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellSpacingHeight: CGFloat = 100
        
        return cellSpacingHeight
    }
    
}
