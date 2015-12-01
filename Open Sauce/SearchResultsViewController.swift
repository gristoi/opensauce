//
//  SearchResultsViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 23/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit
import WebKit

class SearchResultsViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate,UIPopoverPresentationControllerDelegate {

    var url: NSURL!
    var isSite: Bool = false
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var savingLabel: UILabel! {
        didSet {
            savingLabel.layer.masksToBounds = true;
            savingLabel.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: url))
        urlTextField.text = url.host
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.hidden = true
        savingLabel.hidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        activityIndicator.hidden = false
        savingLabel.hidden = false
        OpensauceApi.sharedInstance().scrapeRecipe((webView.request?.mainDocumentURL?.absoluteString)!,
            success: {
                data in
                
                self.activityIndicator.hidden = true
                self.savingLabel.hidden = true
                let alert = UIAlertController(title: NSLocalizedString("Recipe Saved !!", comment: ""), message: NSLocalizedString("Your recipe has been saved successfully.", comment: ""), preferredStyle: .ActionSheet)
                alert.modalPresentationStyle = .Popover
                
                let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default) { action in
                
                }
                alert.addAction(action)
                
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = sender as? UIView
                    presenter.sourceRect = sender.bounds;
                }
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            }, failure: {
                error in
                self.activityIndicator.hidden = true
                self.savingLabel.hidden = true
                let alert = UIAlertController(title: NSLocalizedString("Unable to save this recipe", comment: ""), message: NSLocalizedString("Would you like to bookmark this page instead?.", comment: ""), preferredStyle: .ActionSheet)
                alert.modalPresentationStyle = .Popover
                
                let action = UIAlertAction(title: NSLocalizedString("Bookmark It !!", comment: ""), style: .Default) { action in
                    self.performSegueWithIdentifier("saveBookmark", sender: nil)

                    
                }
                
                let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action in

                }
                alert.addAction(action)
                alert.addAction(cancel)
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = sender as? UIView
                    presenter.sourceRect = sender.bounds;
                }
                self.presentViewController(alert, animated: true, completion: nil)
                
        })
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "saveBookmark") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! BookmarkViewController
            // your new view controller should have property that will store passed value
            viewController.recipeUrl = (webView.request?.mainDocumentURL?.absoluteString)!
        }
        
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
   // urlTextField.resignFirstResponder()
   // webView.loadRequest(NSURLRequest(URL: NSURL(string: urlTextField.text!)!))
    return false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
      //  urlTextField.text = webView.request?.mainDocumentURL?.host
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }

}
