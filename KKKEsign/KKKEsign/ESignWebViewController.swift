//
//  WebViewController.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/23.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

public class ESignWebViewController: KKKWebViewController {

    public var localFileName: String! {
        didSet{
            
        }
    }

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.runPluginJS(["Base", "Console", "Face"])
        self.loadFile()
    }
    
    func loadFile()  {
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
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

