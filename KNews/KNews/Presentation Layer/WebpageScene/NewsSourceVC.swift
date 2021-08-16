//
//  NewsSourceVC.swift
//  iNNNews
//
//  Created by Amin on 18/07/2021.
//

import UIKit
import WebKit

class NewsSourceVC: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    var url : String!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: self.url)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
