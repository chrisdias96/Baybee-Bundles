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
    
    //MARK: Properties
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)

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
