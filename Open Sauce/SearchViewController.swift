//
//  SearchViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 23/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func searchBtn(sender: AnyObject) {
        let search = searchBar.text
        performSegueWithIdentifier("showResults", sender: search)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "showResults") {
            
            let searchString = sender as! String
            let url = NSURL(string: "http://www.google.com/search?q=\(searchString)+site:bbcgoodfood.com")
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! SearchResultsViewController
            // your new view controller should have property that will store passed value
            viewController.url = url
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
