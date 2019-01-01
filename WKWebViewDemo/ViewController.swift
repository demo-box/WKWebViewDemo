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
        setWebView(nil)
    }
    
    private func setWebView(_ config: WKWebViewConfiguration!) {
        if config != nil {
            webView = WKWebView(frame: CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 120), configuration: config)
        } else {
            webView = WKWebView(frame: CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 120))
        }
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
        setWebView(configuration)
        onLoadFileBtnPress("")
    }
    @IBAction func onReceiveH5MsgBtnPress(_ sender: Any) {
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "notification")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        // 重新通过configuration初始化webView
        webView.removeFromSuperview()
        setWebView(configuration)
        onLoadFileBtnPress("")
    }
}

// message handler协议，接收JS传过来的消息
extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // message.body即为JS发送过来的消息，JS可以传递任何类型，会自动转成相应的NS类型
        print(message.body)
        
        // 执行html中的JS方法
        webView.evaluateJavaScript("showMsgOnH5('hello, H5，我已经收到你的消息了')", completionHandler: {
            (any, error) in
            if error != nil {
                print(error!)
            }
        })
    }
}
