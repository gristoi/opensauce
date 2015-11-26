//
//  BookmarkTableViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 25/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class BookmarkTableViewController: UIViewController, UITableViewDelegate {

    var bookmarks = [Bookmark]()
    
    @IBAction func showMenu(sender: AnyObject) {
        presentLeftMenuViewController()
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 131.00/255.0, green: 28.0/255.0, blue: 81.0/255.0, alpha:1.0)
        self.navigationController?.navigationBar.translucent = true;
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        OpensauceApi.sharedInstance().getBookmarks(
            {
                data in
                for bookmark :[String:AnyObject] in data {
                    self.bookmarks.append(Bookmark(dict: bookmark))
                }
                self.tableView.reloadData()
            },
            failure:{
                error in
                print(error)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookmarks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookmarkTableViewCell", forIndexPath: indexPath) as! BookmarkTableViewCell
        cell.bookmarkTitle?.text = bookmarks[indexPath.row].title
        cell.bookmarkSource.text = bookmarks[indexPath.row].host
        cell.background.image = UIImage(named:"sushi")
        OpensauceApi.sharedInstance().getImage(bookmarks[indexPath.row].image_url, completionHandler: {
            responseCode, data in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let image = UIImage(data: data)
                OpensauceApi.Caches.imageCache.storeImage(image, withIdentifier: "\(self.bookmarks[indexPath.row].id)" )
                // Assign image to image view of cell
                cell.background.image = image
                
            })
            }, errorHandler: {
                error in
                print(error)
        });
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "showRecipe") {
            

        }
        
    }
}
