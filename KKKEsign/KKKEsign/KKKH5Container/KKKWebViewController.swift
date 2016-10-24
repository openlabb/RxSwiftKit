//
//  KKKWebViewController.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/21.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import WebKit


@objc public protocol KKKWebErrorsDelegate: NSObjectProtocol {
    optional func KKKWebErrors(URLEroor url: String)
    optional func KKKWebErrors(ReflectionEroor url: String, className: String, functionName: String, message: String)
}

public class KKKWebPlugin: NSObject {
    public var wk: WKWebView!
    public var taskId: Int!
    public var data: String?
    public required override init() {
    }
    public func callback(values: NSDictionary) -> Bool {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(values, options: NSJSONWritingOptions())
            if let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as? String {
                let js = "fireTask(\(self.taskId), '\(jsonString)');"
                self.wk.evaluateJavaScript(js, completionHandler: nil)
                return true
            }
        } catch let error as NSError{
            NSLog(error.debugDescription)
            return false
        }
        return false
    }
    public func errorCallback(errorMessage: String) {
        let js = "onError(\(self.taskId), '\(errorMessage)');"
        self.wk.evaluateJavaScript(js, completionHandler: nil)
    }
}

public class KKKWebViewController: UIViewController, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    
    public var wk: WKWebView!
    public var url: String! {
        didSet{
            if let urlString = self.url {
                if let url = NSURL(string: urlString) {
                    let request = NSURLRequest(URL: url)
                    self.wk.loadRequest(request)
                    NSLog("Load ended: \(self.url)")
                } else {
                    NSLog("URL error!")
                    self.delegate?.KKKWebErrors?(URLEroor: urlString)
                }
            } else {
                NSLog("ERROR!! Please set self.url before viewDidAppear.")
            }
        }
    }
    public var delegate: KKKWebErrorsDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let conf = WKWebViewConfiguration()
        conf.userContentController.addScriptMessageHandler(self, name: "KKKWebWWW")
        
        self.wk = WKWebView(frame: CGRectMake(0, 0, 10, 10), configuration: conf)
        self.wk.UIDelegate = self
        self.wk.navigationDelegate = self
        self.wk.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.wk)
        self.view.sendSubviewToBack(self.wk)
        
        self.runPluginJS(["Base"])
        
        self.view.addConstraint(NSLayoutConstraint(item: self.wk, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.wk, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.wk, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.wk, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

private typealias wkUIDelegate = KKKWebViewController
extension wkUIDelegate {
    
    public func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (aa) -> Void in
            completionHandler()
        }))
        self.presentViewController(ac, animated: true, completion: nil)
    }
}

private typealias wkScriptMessageHandler = KKKWebViewController
extension wkScriptMessageHandler {
    
    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if(message.name == "KKKWebWWW") {
            if let a = message.body as? NSDictionary, className = a["className"]?.description, functionName = a["functionName"]?.description {
                if let cls = NSClassFromString(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName")!.description + "." + className) as? KKKWebPlugin.Type{
                    let obj = cls.init()
                    let functionSelector = Selector(functionName)
                    if obj.respondsToSelector(functionSelector) {
                        obj.wk = self.wk
                        obj.taskId = a["taskId"]?.integerValue
                        obj.data = a["data"]?.description
                        obj.performSelector(functionSelector)
                    } else {
                        let errorMessage = "反射失败! 未找到：\(className)  \(functionName) 方法"
                        NSLog(errorMessage)
                        self.delegate?.KKKWebErrors?(ReflectionEroor: self.url, className: functionName, functionName: functionName, message: errorMessage)
                    }
                } else {
                    let errorMessage = "反射失败！未找到类： \(className) "
                    NSLog(errorMessage)
                    self.delegate?.KKKWebErrors?(ReflectionEroor: self.url, className: className, functionName: functionName, message: errorMessage)
                }
            } else {
                let errorMessage = "反射失败，数据错误: \(message.body)"
                NSLog(errorMessage)
                self.delegate?.KKKWebErrors?(ReflectionEroor: self.url, className: "", functionName: "", message: errorMessage)
            }
        }
    }
}

private typealias wkNavigationDelegate = KKKWebViewController
extension wkNavigationDelegate {
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog(error.debugDescription)
    }
    
    public func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog(error.debugDescription)
    }
    
    
}

private typealias wkRunPluginDelegate = KKKWebViewController
extension wkRunPluginDelegate {
    public func runPluginJS(names: Array<String>) {
        for name in names {
            if let path = NSBundle.mainBundle().pathForResource(name, ofType: "js", inDirectory: "plugins") {
                do {
                    let js = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                    self.wk.evaluateJavaScript(js as String, completionHandler: nil)
                } catch let error as NSError {
                    NSLog(error.debugDescription)
                }
            }
        }
    }
}