//
//  CategoryCollectionViewController.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-14.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UICollectionViewController {

    //MARK: Properties
    var hats = Hats()
    var headbands = Headbands()
    var gloves = Gloves()
    var socks = Socks()
    
    var category: String!
    var itemsArray = [Photo]()

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        
//        let width = (view.frame.size.width - 20) / 2
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.estimatedItemSize = CGSize(width: width, height: 200)

        //Add the title and load the photo depending on category chosen
        self.title = category
        switch category {
        case "HATS":
            itemsArray = hats.hatPhotos
        case "HEADBANDS":
            itemsArray = headbands.headbandPhotos
        case "GLOVES":
            itemsArray = gloves.glovePhotos
        case "SOCKS":
            itemsArray = socks.sockPhotos
        default:
            fatalError("Unknown category passed to CategoryCollectionViewController")
        }
    }
    
    // MARK: - Prepare

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "itemDetailSegue",
            let itemDetailVC = segue.destination as? itemDetailViewController,
            let selectedIndex = collectionView.indexPathsForSelectedItems?.first {
            itemDetailVC.photo = itemsArray[selectedIndex.row]
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemsArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! PhotoCollectionViewCell
    
        let categoryPassed = itemsArray[indexPath.row]
        
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        // Configure the cell
        cell.photoImage.image = categoryPassed.image
        cell.photoTitle.text = categoryPassed.title
        cell.photoPrice.text = "$\(categoryPassed.price)"
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemDetailSegue", sender: self)
    }

}

//MARK: Extensions
extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let spacing = CGFloat(5)
        
        return spacing
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        
        return insets
    }
    
}

extension CategoryCollectionViewController: UIViewControllerPreviewingDelegate {
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    guard let tappedIndexPath = collectionView.indexPathForItem(at: location)
      else { return nil }
    
    let photo = itemsArray[tappedIndexPath.row]
    
    guard let viewController = storyboard?.instantiateViewController(withIdentifier:"itemDetailViewController") as? itemDetailViewController
      else { return nil }
    
    viewController.photo = photo
    return viewController
  }
  
  func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                         commit viewControllerToCommit: UIViewController) {
    
    navigationController?.show(viewControllerToCommit, sender: self)
  }
}
