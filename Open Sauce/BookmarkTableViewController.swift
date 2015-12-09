//
//  BookmarkTableViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 25/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit
import CoreData

class BookmarkTableViewController: UIViewController {

    // Keep track of insertions, deletions and updates
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    var refreshControl:UIRefreshControl!
    
    @IBAction func showMenu(sender: AnyObject) {
        presentLeftMenuViewController()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    //# MARK: - NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Bookmark")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 131.00/255.0, green: 28.0/255.0, blue: 81.0/255.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        fetchedResultsController.delegate = self
        getBookmarks()
    }
    
    
    func refresh(sender:AnyObject)
    {
        for bookmark in fetchedResultsController.fetchedObjects as! [Bookmark] {
            if bookmark.image != nil {
                FudiApi.Caches.imageCache.storeImage(nil, withIdentifier: "bookmarks-\(bookmark.id)")
            }
            self.sharedContext.deleteObject(bookmark)
        }
        CoreDataStackManager.sharedInstance().saveContext()
        getBookmarks()
    }
    
    func getBookmarks() {
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print(error)
        }
        if let foundBookmarks = fetchedResultsController.fetchedObjects as? [Bookmark] {

            if foundBookmarks.isEmpty {
                FudiApi.sharedInstance().getBookmarks(self.sharedContext,
                    success: {
                        bookmarks in
                        CoreDataStackManager.sharedInstance().saveContext()
                        self.refreshControl?.endRefreshing()
                    },
                    failure :
                    {
                        error in
                        self.refreshControl?.endRefreshing()
                        let message = error["Error"] as! String
                        self.refreshControl?.endRefreshing()
                        let alertController = UIAlertController(title: "Error getting bookmarks", message:message, preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)
                    }
                    
                )
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){

        if (segue.identifier == "showBookmark") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! BookmarkDetailViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let bookmark = fetchedResultsController.objectAtIndexPath(indexPath!) as! Bookmark
            viewController.url = NSURL(string: bookmark.originalLink)

        }
        
    }
    

}

extension BookmarkTableViewController: UITableViewDelegate {
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numRows = fetchedResultsController.fetchedObjects?.count ?? 0
        
        if numRows == 0{
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            emptyLabel.text = "You currently have no bookmarks saved"
            emptyLabel.textAlignment = .Center
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        } else {
            return numRows
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookmarkTableViewCell", forIndexPath: indexPath) as! BookmarkTableViewCell
        let bookmark = fetchedResultsController.objectAtIndexPath(indexPath) as! Bookmark
        cell.bookmarkTitle?.text = bookmark.title
        cell.bookmarkSource.text = bookmark.host
        cell.background.image = UIImage(named:"sushi")
        FudiApi.sharedInstance().getImage(bookmark.image_url, completionHandler: {
            responseCode, data in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let image = UIImage(data: data)
                FudiApi.Caches.imageCache.storeImage(image, withIdentifier: "\(bookmark.id)" )
                // Assign image to image view of cell
                cell.background.image = image
                
            })
            }, errorHandler: {
                error in
                print(error)
        });
        return cell
    }
   
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let bookmark = fetchedResultsController.objectAtIndexPath(indexPath) as! Bookmark
            sharedContext.deleteObject(bookmark)
        }
    }
}


extension BookmarkTableViewController: NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            insertedIndexPaths.append(newIndexPath!)
            break
        case .Delete:
            deletedIndexPaths.append(indexPath!)
            break
        case .Update:
            updatedIndexPaths.append(indexPath!)
            break
        case .Move:
            print("move")
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}
