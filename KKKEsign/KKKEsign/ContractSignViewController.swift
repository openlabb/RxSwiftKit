//
//  ContractSignViewController.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/25.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

class ContractSignViewController: UIViewController{
    let contractImageView:UIImageView = UIImageView(image: UIImage.init(named:"contract"))
    let signImageView:DragView = DragView()

    let faceBtn:UIButton = UIButton()
    let smsBtn:UIButton = UIButton()

    // MARK: -------Life Cycle
    
    //单例
    static func shareOne()->ContractSignViewController{
        struct shareInstance{
            static var onceToken : dispatch_once_t = 0
            static var single:ContractSignViewController?
        }
        dispatch_once(&shareInstance.onceToken,{
            shareInstance.single = shareOne()
            }
        )
        return shareInstance.single!
    }
    
    private init(){
        super.init(nibName:nil,bundle:nil)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backColor = kBackColor
        self.view.backgroundColor = backColor
        self.navigationController?.navigationBar.hidden = false
        self.title = "拖拽签名"
        self.addSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    // MARK: -------子控件
    
    func addSubviews()  {
        self.addContract()
        self.addSignImageView()

        let width =  UIScreen.mainScreen().bounds.width
        let v = self.view
        
        //刷脸确认按钮
        let btn = faceBtn
        v.addSubview(btn)
        btn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(-10)
            make.height.equalTo(40)
            make.width.equalTo(120)
            make.left.equalTo(width/2 - 20 - 120)
        }
        btn.layer.cornerRadius = 15
        btn.setTitle("刷脸确认", forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(17)
        btn.backgroundColor = kBaseColor
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.titleLabel?.textAlignment = .Center
        btn.addTarget(self, action: #selector(face), forControlEvents: UIControlEvents.TouchUpInside)
        
        //短信确认按钮
        let btn1 = smsBtn
        v.addSubview(btn1)
        btn1.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(-10)
            make.left.equalTo(width/2 + 20)
            make.height.equalTo(40)
            make.width.equalTo(120)
          }
        btn1.layer.cornerRadius = 15
        btn1.setTitle("短信确认", forState: .Normal)
        btn1.titleLabel?.font = UIFont.systemFontOfSize(17)
        btn1.backgroundColor = kBaseColor
        btn1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn1.titleLabel?.textAlignment = .Center
        btn1.addTarget(self, action: #selector(sms), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.setLeftNavBarBack()
    }
    
    func face() {
        KKKRouter.goToFace()
    }
    
    func sms(){
        KKKRouter.goToSMS()

    }

    func addContract(){
        let width =  UIScreen.mainScreen().bounds.width

        let v = self.view
        v.addSubview(contractImageView)
        contractImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(v).offset(20)
            make.left.equalTo(10)
            make.width.equalTo( width - 20)
            make.height.equalTo(contractImageView.snp_width).multipliedBy(767/462.0)
        }
    }
    
    func addSignImageView(){
        let v = contractImageView
        v.addSubview(self.signImageView)
        signImageView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo( -100)
            make.left.equalTo(40)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        let filePath = SignatureViewController.imagePath()
        if NSFileManager.defaultManager().fileExistsAtPath(filePath){
            self.signImageView.image = UIImage.init(contentsOfFile: filePath)
            self.signImageView.hidden = false
            print(filePath)
        }else{
            self.signImageView.hidden = true
        }
        signImageView.userInteractionEnabled = true
        self.contractImageView.userInteractionEnabled = true
    }

    
    func addLeftBarAction() -> Void {
        let item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = item
    }
    
    func goBack()  {
        KKKRouter.popViewController()
    }
    
    

    
    
}
