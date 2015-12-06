//
//  BookmarkTableViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 25/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit
import CoreData

class BookmarkTableViewController: UIViewController, UITableViewDelegate {

    // Keep track of insertions, deletions and updates
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    var refreshControl:UIRefreshControl!

    var bookmarks = [Bookmark]()
    
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
                OpensauceApi.Caches.imageCache.storeImage(nil, withIdentifier: "bookmarks-\(bookmark.id)")
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
                OpensauceApi.sharedInstance().getBookmarks(self.sharedContext,
                    success: {
                        bookmarks in
                        CoreDataStackManager.sharedInstance().saveContext()
                        self.refreshControl?.endRefreshing()
                    },
                    failure :
                    {
                        error in
                        print(error)
                        self.refreshControl?.endRefreshing()
                    }
                    
                )
                
            }
        }
    }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookmarkTableViewCell", forIndexPath: indexPath) as! BookmarkTableViewCell
        let bookmark = fetchedResultsController.objectAtIndexPath(indexPath) as! Bookmark
        cell.bookmarkTitle?.text = bookmark.title
        cell.bookmarkSource.text = bookmark.host
        cell.background.image = UIImage(named:"sushi")
        OpensauceApi.sharedInstance().getImage(bookmark.image_url, completionHandler: {
            responseCode, data in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let image = UIImage(data: data)
                OpensauceApi.Caches.imageCache.storeImage(image, withIdentifier: "\(bookmark.id)" )
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
}
