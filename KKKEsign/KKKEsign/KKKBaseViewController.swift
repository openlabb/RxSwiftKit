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
    
    func setLeftNavBarBack(){
        self.navigationController?.navigationBar.backgroundColor = UIColor.redColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = kBaseColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont.systemFontOfSize(17)]
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.backButton())
        
        let item = UIBarButtonItem(title: " < 返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goBackBaseUIViewController))
        self.navigationItem.leftBarButtonItem = item

    }
    
    
    func backButton() -> UIButton {
//        let icon : UIImage = UIImage.init(named: "back")!
        let btn :UIButton = UIButton()
        btn.backgroundColor = kBaseColor
//        btn.setImage(icon, forState: .Normal)
//        btn.setImage(icon, forState: .Highlighted)
//        btn.setBackgroundImage(icon, forState: .Normal)
//        btn.setBackgroundImage(icon, forState: .Highlighted)
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        btn.setTitle("返回", forState: .Normal)
        btn.setTitle("返回", forState: .Highlighted)
        //相对图片
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        btn.titleLabel?.textColor = UIColor.whiteColor()
        btn.titleLabel?.font = UIFont.systemFontOfSize(17)
        btn.addTarget(self, action: #selector(goBackBaseUIViewController), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }
    
    func goBackBaseUIViewController()  {
        self.navigationController?.popViewControllerAnimated(true)
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
