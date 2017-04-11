//
//  ViewController.swift
//  RevlImageSearch
//
//  Created by Michael Dautermann on 4/10/17.
//  Copyright © 2017 Michael Dautermann. All rights reserved.
//

import UIKit
import MobileCoreServices // for the UTType

class RVViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var searchBar : UISearchBar!
    let searchResults = RVSearchResults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName:searchResults.UpdatedSearchResults, object:nil, queue:nil, using:refreshOurCollection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshOurCollection(notification:Notification) -> Void {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            
            let imageDetailVC = segue.destination as! RVImageDetailViewController
            
            if let indexPaths = self.collectionView.indexPathsForSelectedItems
            {
                let indexPath = indexPaths[0]
                let imageObject = searchResults.resultLinks[indexPath.row]

                imageDetailVC.imageObject = imageObject
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + UIScreen.main.bounds.size.height
        
        let cellWidth = self.cellWidth()
        
        let currentIndex = (offsetY / cellWidth) * 4 // four cells per line

        // print("offset Y \(offsetY), currentIndex = \(currentIndex)")

        if Int(floor(currentIndex)) > searchResults.resultLinks.count
        {
            searchResults.getResultsFor(searchString: searchBar.text!, fromStartIndex: searchResults.resultLinks.count)
        }
    }
    
    func cellWidth() -> CGFloat
    {
        // four cells per line of the screen
        let numberOfCell: CGFloat = 4
        let cellWidth = UIScreen.main.bounds.size.width / numberOfCell
        return cellWidth
    }
    
    // MARK: Search bar stuff
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults.getResultsFor(searchString: searchBar.text!, fromStartIndex: 0)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.resultLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RVCollectionViewCell", for: indexPath) as! RVCollectionViewCell
        
        cell.setImageObject(searchResults.resultLinks[indexPath.row])

        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.cellWidth()
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    // these three functions allow the "Copy" menu to appear for a long press in the collection view...
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        let selectorString = NSStringFromSelector(action)
        
        if selectorString == "copy:"
        {
            return true
        }
        
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        let selectorString = NSStringFromSelector(action)
        
        if selectorString == "copy:"
        {
            let imageView = UIImageView()
            let imageObject = searchResults.resultLinks[indexPath.row]
            
            imageView.sd_setImage(with: imageObject.contentURL, completed: { (image, error, cacheType, url) in
                if error == nil
                {
                    if let pasteboard = UIPasteboard(name: .general, create: false)
                    {
                        pasteboard.setPersistent(true)
                    
                        let imageData = UIImagePNGRepresentation(image!)
                        
                        pasteboard.setData(imageData!, forPasteboardType: kUTTypePNG as String)
                    }
                } else {
                    // another great place for an alert
                    print("did not get the image from \(url!.absoluteString) - \(error!.localizedDescription)")
                }
            })
        }
    }
}

