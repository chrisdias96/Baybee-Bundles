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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: Extensions
extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    
    
    
}
