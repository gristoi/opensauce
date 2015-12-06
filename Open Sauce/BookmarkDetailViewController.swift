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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func webViewDidFinishLoad(webView: UIWebView) {
        hostName.text = webView.request?.mainDocumentURL?.host
    }
}