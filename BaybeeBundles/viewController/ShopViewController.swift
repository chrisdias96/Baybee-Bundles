//
//  ShopViewController.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-14.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit
import CoreData

class ShopViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    //MARK: Properties
    var moc: NSManagedObjectContext!
    var categories = Categories()
    var passedCategories: String!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Do any additional setup after loading the view.

    }
    
    // MARK: - Prepare

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let selectedIndex = tableView.indexPathForSelectedRow
            else { return }
        
        let category = categories.categories[selectedIndex.section]
        let title = category.title
        
        if let categoryCollectionVC = segue.destination as? CategoryCollectionViewController {
            categoryCollectionVC.category = title
        }

    }

}//end Class

//MARK: UITableViewDelegate, UITableViewDataSource
extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
            
        let categorySection = categories.categories[indexPath.section]

        cell.catTitle.text = categorySection.title
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}
