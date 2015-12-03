//
//  PopupViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 28/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, UICollectionViewDelegate {

    var recipeUrl: String!
    var images = [[String: AnyObject]]()
    var selectedImage: String?
    
    @IBOutlet weak var addATitle: UILabel!
    
    @IBOutlet weak var bookmarkTitle: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func saveBookmarkClicked(sender: UIButton) {
        
        OpensauceApi.sharedInstance().saveBookmark(recipeUrl, title: bookmarkTitle.text!, image_url: selectedImage!,
            success: {
                data in
                print("success")
                self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: {
                error in
                print("failure")

                self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OpensauceApi.sharedInstance().scrapeBookmarkImages(recipeUrl,
            success: {
                data in
                for image:[String:AnyObject] in data {
                    if(self.verifyUrl(image["src"] as? String))
                    {
                        self.images.append(image)
                    }
                }
                self.collectionView.reloadData()
                
            }, failure: {
                error in
                
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var saveBookmarkButton: UIButton!
    
    
    @IBAction func cancelClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Get reference to Photo object at cell in question
        let image = images[indexPath.row]
        
        // Get reference to PhotoCell object at cell in question
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("bookmarkCell", forIndexPath: indexPath) as! BookmarkCollectionViewCell
        OpensauceApi.sharedInstance().getImage(image["src"] as! String, completionHandler: {
            responseCode, data in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let image = UIImage(data: data)
                //OpensauceApi.Caches.imageCache.storeImage(image, withIdentifier: "sites-\(site.id)")
                // Assign image to image view of cell
                cell.imageView!.image = image
            })
            }, errorHandler: {
                error in
                print(error)
        });
        
        return cell
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
    
    // MARK: - UICollectionViewDelegate Methods
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let row = images[indexPath.row]
        selectedImage = row["src"] as? String
    }

    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }

}
