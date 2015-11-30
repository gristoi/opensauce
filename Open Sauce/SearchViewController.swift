//
//  SearchViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 23/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate,  UISearchBarDelegate {

    var sites = [Site]()
    var isSite: Bool = false
    
    @IBOutlet weak var menuLeftBtn: UIBarButtonItem!
    
    
    @IBAction func menuLeftClicked(sender: AnyObject) {
        presentLeftMenuViewController()
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self;
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 131.00/255.0, green: 28.0/255.0, blue: 81.0/255.0, alpha:1.0)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 131.00/255.0, green: 28.0/255.0, blue: 81.0/255.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.translucent = false
        OpensauceApi.sharedInstance().getSites(
           {
                data in
            
          _ = data.map {
                site in
                print(site)
            self.sites.append(Site(dict:site))
            }
            self.collectionView.reloadData()
            },
            failure :
            {
                error in
            }
            
) 
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        
        let width = floor((self.collectionView.frame.size.width/3) - 2)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "showResults") {
            let url = sender as! NSURL
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! SearchResultsViewController
            // your new view controller should have property that will store passed value
            viewController.url = url
            viewController.isSite = isSite
        }
        
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let search = searchBar.text
        let escapedSearch = search!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        let url = NSURL(string: "http://www.google.com/search?q=\(escapedSearch!)")
        isSite = false
        performSegueWithIdentifier("showResults", sender: url)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sites.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Get reference to Photo object at cell in question
        let site = sites[indexPath.row] 
        
        // Get reference to PhotoCell object at cell in question
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("siteCollectionCell", forIndexPath: indexPath) as! SiteCollectionViewCell
        cell.label.text = site.name
        print(site.name)
            OpensauceApi.sharedInstance().getImage(site.img_src, completionHandler: {
                responseCode, data in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let image = UIImage(data: data)
                    OpensauceApi.Caches.imageCache.storeImage(image, withIdentifier: "sites-\(site.id)")
                    // Assign image to image view of cell
                    cell.imageView.image = image
                })
                }, errorHandler: {
                    error in
                    print(error)
            });
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate Methods
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let host = sites[indexPath.row].host
        let url = NSURL(string: "http://\(host)")
        isSite = true
        performSegueWithIdentifier("showResults", sender: url)
    }
    

}
