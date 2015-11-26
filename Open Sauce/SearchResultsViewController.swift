//
//  SearchResultsViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 23/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit
import WebKit

class SearchResultsViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate {

    var url: NSURL!
    var isSite: Bool = false
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: url))
        urlTextField.text = url.absoluteString
        if !isSite {
            saveButton.enabled = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
    }
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        OpensauceApi.sharedInstance().scrapeRecipe(urlTextField.text!,
            success: {
                data in
                
            }, failure: {
                error in
                
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    urlTextField.resignFirstResponder()
    webView.loadRequest(NSURLRequest(URL: NSURL(string: urlTextField.text!)!))
    return false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        urlTextField.text = webView.request?.mainDocumentURL?.absoluteString
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
