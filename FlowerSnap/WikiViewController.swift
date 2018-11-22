//
//  DetailViewController.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2018/11/16.
//  Copyright © 2018 陆依鸣. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var searchTerm: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let myURL = URL(string:"https://www.apple.com")
//        let myRequest = URLRequest(url: myURL!)
//        webView.load(myRequest)
        
        if let url = URLComponents(scheme: "https",
                                   host: "en.wikipedia.org",
                                   path: "/w/index.php",
                                   queryItems: [URLQueryItem(name: "search", value: self.searchTerm!), URLQueryItem(name: "search", value: self.searchTerm!)]).url {
            
            print(url)
            
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
        }
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

extension URLComponents {
    init(scheme: String, host: String, path: String, queryItems: [URLQueryItem]) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}

