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
        
        OpensauceApi.sharedInstance().scrapeRecipe((webView.request?.mainDocumentURL?.absoluteString)!,
            success: {
                data in
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
                
                
        })
        
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
