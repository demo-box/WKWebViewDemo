//
//  ViewController.swift
//  WKWebViewDemo
//
//  Created by 悖论 on 2019/1/1.
//  Copyright © 2019 beilunyang. All rights reserved.
//

import UIKit
// 导入wkWebView
import WebKit

private let screenH = UIScreen.main.bounds.height
private let screenW = UIScreen.main.bounds.width

class ViewController: UIViewController {
    var webView: WKWebView!
    var loadFileBtn: UIButton!
    var loadURLBtn: UIButton!
    var injectJSBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        // 初始化WKWebView
        webView = WKWebView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 80))
        view.addSubview(webView)
    }
    @IBAction func onLoadFileBtnPress(_ sender: Any) {
        // 加载本地HTML
        let fileURL = Bundle.main.url(forResource: "Html/index", withExtension: "html")
        webView.loadFileURL(fileURL!, allowingReadAccessTo: Bundle.main.bundleURL)
    }
    @IBAction func onLoadURLBtnPress(_ sender: Any) {
        // 通过网址加载HTML
        let url = URL(string: "https://beilunyang.github.io")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    @IBAction func onInjectJSBtnPress(_ sender: Any) {
        let js = "document.body.style.background = 'red'"
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        // 重新通过configuration初始化webView
        webView.removeFromSuperview()
        webView = WKWebView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 80), configuration: configuration)
        view.addSubview(webView)
        onLoadFileBtnPress("")
    }
}
