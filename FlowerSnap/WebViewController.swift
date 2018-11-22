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
    
    enum Site {
        case Bing
        case Wiki
        case None
    }
    
    var searchTerm: String?
    var site: Site = .None
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://cn.bing.com/images/search?q=barberton+daisy
        
        var url: URL?
        
        switch self.site {
        case .Bing:
            url = URLComponents(scheme: "https",
                                host: "cn.bing.com",
                                path: "/images/search",
                                queryItems: [URLQueryItem(name: "q", value: self.searchTerm!)]).url
        case .Wiki:
            url = URLComponents(scheme: "https",
                               host: "en.wikipedia.org",
                               path: "/w/index.php",
                               queryItems: [URLQueryItem(name: "search", value: self.searchTerm!)]).url
        default: return
        }
        
        if let searchUrl = url {
            
            print(searchUrl)

            webView.load(URLRequest(url: searchUrl))
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

