//
//  WebViewController.swift
//  GurunaviAPI
//
//  Created by 佐藤大介 on 2018/05/04.
//  Copyright © 2018年 sato daisuke. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var selectedRest: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myWebView = WKWebView()
        myWebView.frame = self.view.frame
        self.view.addSubview(myWebView)
        
        let url = self.selectedRest!.url!
        let myURL = NSURL(string: url)
        let myURLReq = NSURLRequest(url: myURL! as URL)
        myWebView.load(myURLReq as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
