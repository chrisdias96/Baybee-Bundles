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
    let minRowHeight: CGFloat = 50
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Do any additional setup after loading the view.

    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Basic functionality to open app using spotlight
        let userActivity = NSUserActivity(activityType: "ca.stclairconnect.dias01.christopher.BaybeeBundles")
        
        userActivity.title = "Shop"
        userActivity.isEligibleForSearch = true
        userActivity.isEligibleForPublicIndexing = true
        
        self.userActivity = userActivity
        self.userActivity?.becomeCurrent()
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        //Get the tableViewHeight
//        let tHeight = tableView.frame.height
//        //The height of the items divided by how many
//        let temp = tHeight / CGFloat(categories.categories.count)
//        //If temp is great then evenheight, return it other return evenheight
//        return temp > minRowHeight ? temp : minRowHeight
//    }

    
}
