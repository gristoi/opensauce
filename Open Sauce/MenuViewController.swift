//
//  LeftMenuViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import Foundation
import UIKit

class LeftMenuViewController: UIViewController {
    
    @IBAction func onLogout(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.logoutUser()
    }
    
    @IBOutlet weak var profilePic: UIImageView! {
        didSet{
            self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
            self.profilePic.clipsToBounds = true;
            self.profilePic.layer.borderWidth = 2.0;
            self.profilePic.layer.borderColor = UIColor.whiteColor().CGColor;
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 74.0/255.0, green: 57.0/255.0, blue: 73.0/255.0, alpha:1.0)
        
        tableView.separatorStyle = .None
        tableView.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleWidth]
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.bounces = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


// MARK : TableViewDataSource & Delegate Methods

extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let titles: [String] = ["EXPLORE","RECIPES","BOOKMARKS", "LOGOUT"]
        
        let images: [String] = ["search", "books", "bookmark", "logout"]
        
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont(name: "Lato", size: 18)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.text  = titles[indexPath.row]
        cell.selectionStyle = .None
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        

        case 0:
            
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: storyboard!.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController)
            sideMenuViewController?.hideMenuViewController()
            break
        case 1:
            //var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: storyboard!.instantiateViewControllerWithIdentifier("RecipeTableViewController") as! RecipeTableViewController)
            sideMenuViewController?.hideMenuViewController()
            break
        case 2:
            
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: storyboard!.instantiateViewControllerWithIdentifier("BookmarkTableViewController") as! BookmarkTableViewController)
            sideMenuViewController?.hideMenuViewController()
            break
        case 3:
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.logoutUser()
            break;
        default:
            break
        }
        
        
    }
    
}

