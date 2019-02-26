//
//  WebViewController.swift
//  Blogger
//
//  Created by IMCS2 on 2/26/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController,WKUIDelegate {

    @IBOutlet  var webView: WKWebView!
    var webLink: String = ""
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let myURL = URL(string:webLink)
       
       
        let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        
            }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
