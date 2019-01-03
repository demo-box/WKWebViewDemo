# WKWebViewDemo
IOS WKWebView控件Demo

## 使用总结
### 设置WKWebView控件
```swift
import WebKit

let webView = WKWebView(frame: CGRect(x: 0, y: 120, width: screenW, height: screenH - 120))
// 或者
let webView = WKWebView(frame: CGRect(x: 0, y: 120, width: screenW, height: screenH - 120), configuration: configuration)

view.addSubView(webView)
```

### 加载网页
#### 加载本地H5页面
```swift
let fileURL = Bundle.main.url(forResource: "Html/index", withExtension: "html")
webView.loadFileURL(fileURL!, allowingReadAccessTo: Bundle.main.bundleURL)
```
#### 加载远程H5页面
```swift
let url = URL(string: "https://beilunyang.github.io")
let request = URLRequest(url: url!)
webView.load(request)
```

### Native向H5注入JS代码
```swift
let js = "js代码"

// 实例化WKUserScript
let userScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

// 实例化WKUserContentController
let userContentController = WKUserContentController()
userContentController.addUserScript(userScript)

// 实例化WKWebViewConfiguration
let configuration = WKWebViewConfiguration()
configuration.userContentController = userContentController

// 实例化WKWebView时, 传入configuration
let webView = WKWebView(frame: CGRect(x: 0, y: 120, width: screenW, height: screenH - 120), configuration: configuration)
```

### Native与H5通信
#### H5端
```javascript
// 向native发送消息
if (window.webkit) {
  window.webkit.messageHandlers.notification.postMessage("this is a h5 message");
}

// 当native接收到h5发送的消息后的回调函数
function showMsgOnH5(str) {
  var msg = document.createElement('p');
  msg.innerText = str;
  document.getElementById("app").appendChild(msg);
}
```
#### Native端
实例化WKWebView控件时，需要设置Configuration对象
```swift
let userContentController = WKUserContentController()  
// name可以是任意字符串
// H5端发送postMessage: window.webkit.messageHandlers.<name>.postMessage
userContentController.add(self, name: "notification")
let configuration = WKWebViewConfiguration()
configuration.userContentController = userContentController
let webView = WKWebView(frame: CGRect(x: 0, y: 120, width: screenW, height: screenH - 120), configuration: configuration)
```
`userContentController add`的对象需要实现`WKScriptMessageHandler`协议, 来接收H5发送过来的消息;   
Native可以通过`webView.evaluateJavaScript`执行H5中的JS方法
```swift
extension ViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    // message.body即为JS发送过来的消息，JS可以传递任何类型，会自动转成相应的NS类型
    print(message.body)
     
    // 执行H5中的JS方法
    webView.evaluateJavaScript("showMsgOnH5('hello, H5，我已经收到你的消息了')", completionHandler: {
      (any, error) in
        if error != nil {
          print(error!)
        }
    })
  }
}
```

### 显示加载进度条
需要设置`UIProgressView`控件   
```swift
// 设置UIProgressView
let progressView = UIProgressView(progressViewStyle: .bar)
progressView.frame = CGRect(x: 0, y: 140, width: screenW, height: 5)
view.addSubview(progressView)
```
通过`KVO（Key Value Observing）`监听`webView`的`estimatedProgress`属性的变化
```swift
// 监听webview estimatedProgress属性的变化
webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
```
```swift
// webView.addObserver的对象, 需要实现observerValue方法，这里是self,即VC
extension ViewController {
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      progressView.isHidden = webView.estimatedProgress == 1
      progressView.setProgress(Float(webView.estimatedProgress), animated: true)
    }
  }
}
```

## 参考资料
* https://nshipster.cn/wkwebkit/
* https://my.oschina.net/u/2399303/blog/1610638
* https://blog.csdn.net/MHTios/article/details/80314073
* ios.8.by.Tutorials