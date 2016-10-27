//
//  WebViewController.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/23.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import WebKit

public class ESignWebViewController: KKKWebViewController {
    
    public var localFileName: String! {
        didSet{
            
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.runPluginJS(["Console", "Plug","testjs"])
        self.loadFile()
        self.wk.scrollView.scrollEnabled = false
        
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController != nil {
            self.navigationController?.navigationBar.hidden = true
        }
    }
    
    
    public func  loadFile()  {
        if let fileName = self.localFileName {
            if let resourceUrl = NSBundle.mainBundle().URLForResource(fileName, withExtension: "html",subdirectory: "www") {
                if NSFileManager.defaultManager().fileExistsAtPath(resourceUrl.path!) {
                    print("加载本地网页文件:\(fileName).html")
                    let pathURL:NSURL = (NSBundle.mainBundle().resourceURL?.URLByAppendingPathComponent("www",isDirectory: true))!
                    self.wk.loadFileURL(resourceUrl, allowingReadAccessToURL: pathURL)
                }else{
                    print("文件未找到:\(fileName).html")
                }
            }
        } else {
            NSLog("ERROR!! Please set self.localFileName before viewDidAppear.")
        }
        
    }
    
    override public func prefersStatusBarHidden()->Bool{
        return true
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    public func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //页面开始加载
        print("---didStartProvisionalNavigation\n")
        
    }
    
    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        //内容开始返回
        print("---didCommitNavigation\n")
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        //页面加载完成
        let path:NSString = ((webView.URL?.relativePath)! as NSString).lastPathComponent
        print("---页面加载完成:didFinishNavigation:--\n\r✅--\(path)")
        if path.isEqualToString("userID.html") || path.isEqualToString("userCenter.html") {
            //人脸注册
            EsignPlug.deleteFaceGID()
            self.runPluginJS(["Console", "Plug","testjs"])
        }
        else{
            var arr:Array<String> = []
            arr.append("x_one2.html")
            arr.append("mian_5_2.html")
            arr.append("mian_6_1.html")
            arr.append("mian_7_1.html")
            arr.append("faceSign.html")
            arr.append("mian_3_1.html")
            arr.append("mian_3_2.html")
            arr.append("x_two.html")
            arr.append("x_two.html")
            arr.append("x_two2.html")
            arr.append("x_one.html")
            arr.append("mian_1.html")
            //这些页面都涉及到跳转到原生的界面，不让走html
            if arr.contains(path as String) {
                //签约识别
                self.runPluginJS(["Console", "Plug","testjs"])
            }
        }
    }
    
    public func  webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //收到服务器跳转请求
        print("---didReceiveServerRedirectForProvisionalNavigation\n")
        
    }
    
    public func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        //收到响应，决定是否跳转
        decisionHandler(.Allow)
        print("---decidePolicyForNavigationResponse\n")
        
        
    }
    
    
    
}

