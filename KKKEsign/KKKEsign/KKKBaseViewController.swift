//
//  BaseViewController.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/13.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func showHint(message: String) {
            KKKToast.showToast(message)
    }
    
    // MARK: -------Life Cycle
    //    //单例
    //    static func shareOne()->KKKLoginViewController{
    //        struct shareInstance{
    //            static var onceToken : dispatch_once_t = 0
    //            static var single:KKKLoginViewController?
    //        }
    //        dispatch_once(&shareInstance.onceToken,{
    //            shareInstance.single = shareOne()
    //            }
    //        )
    //        return shareInstance.single!
    //    }
    
    //    private init(){
    //        super.init(nibName:nil,bundle:nil)
    //    }
    
    
    //    override func viewDidDisappear(animated: Bool) {
    //        super.viewDidDisappear(animated)
    //    }
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        let backColor = kBackColor
    //        self.view.backgroundColor = backColor
    //        self.addSubviews()
    //        self.binding()
    //        self.bindingData()
    //    }
    //
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //    }
    //
    //    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    //        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //    }
    //
    //
    //    // MARK: -------子控件
    //
    //    func addSubviews()  {
    //    }
    //
    //
    //    // MARK: -------VM与V绑定
    //    func binding()  {
    //    }
    //
    //    // MARK: -------数据绑定
    //    func bindingData()  {
    //    }
    //
}
