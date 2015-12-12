//
//  BookmarkDetailViewController.swift
//  Fudi
//
//  Created by Ian Gristock on 05/12/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class BookmarkDetailViewController: UIViewController, UIWebViewDelegate {

    var url: NSURL!
    
    @IBOutlet weak var hostName: UITextField!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var host: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.hidden = true
        if(!FudiApi.checkNetwork())
        {
            let alertController = UIAlertController(title: "Network Error", message:"There appears to be no network connection", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(alertController, animated: true, completion:nil)
            })
            return
        }
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: url))
        hostName.text = url.host
        
        // Do any additional setup after loading the view.
    }

    @IBAction func closeButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func forwardHIstory(sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func backHistory(sender: AnyObject) {
        webView.goBack()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        hostName.text = webView.request?.mainDocumentURL?.host
        loadingIndicator.stopAnimating()
        loadingIndicator.hidden = true
    }
}