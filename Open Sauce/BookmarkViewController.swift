//
//  PopupViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 28/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController, UICollectionViewDelegate {

    var recipeUrl: String!
    var images = [[String: AnyObject]]()
    var selectedImage: String?
    
    @IBOutlet weak var addATitle: UILabel!
    
    @IBOutlet weak var bookmarkTitle: UITextField! {
        didSet {
            bookmarkTitle.delegate = self
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    @IBAction func saveBookmarkClicked(sender: UIButton) {
        
        if bookmarkTitle.text?.isEmpty == true || selectedImage == nil{
            let alertController = UIAlertController(title: "Please complete the bookmark", message: "Both a title and image must be supplied", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            return
        }
        
        FudiApi.sharedInstance().saveBookmark(recipeUrl, title: bookmarkTitle.text!, image_url: selectedImage!, context: self.sharedContext,
            success: {
                data in
                self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: {
                error in
                print("failure")

                self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FudiApi.sharedInstance().scrapeBookmarkImages(recipeUrl,
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
        FudiApi.sharedInstance().getImage(image["src"] as! String, completionHandler: {
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
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell!.layer.borderWidth = 3.0
        cell!.layer.borderColor = UIColor.whiteColor().CGColor
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

extension BookmarkViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
