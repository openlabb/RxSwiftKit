//
//  SignatureViewController.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/25.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

class SignatureViewController: UIViewController{
    let redrawBtn:UIButton = UIButton()
    var signView :SignatureView = SignatureView.init(frame: CGRectZero)
    let imageView:UIImageView = UIImageView()
    // MARK: -------Life Cycle
    
    //单例
    static func shareOne()->SignatureViewController{
        struct shareInstance{
            static var onceToken : dispatch_once_t = 0
            static var single:SignatureViewController?
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
        self.title = "手绘设置签名"
        self.navigationController?.navigationBar.hidden = false
        self.addSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadImageView()
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
//        self.addLeftBarAction()
        self.setLeftNavBarBack()
        self.addRightBarAction()
        self.addSignatureView()
        self.addImageView()
        self.addRedrawBtn()

    }
    
    func addImageView(){
        let v = self.view
        v.addSubview(self.imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(50)
            make.left.equalTo(v).offset(20/2)
            make.height.equalTo(400)
            make.width.equalTo(v.snp_width).offset(20)


        }
        imageView.hidden = true
    }
    
    
    class func imagePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, .UserDomainMask, true)
        let filePath = paths[0].stringByAppendingString("/\(KKKUserService.shareInstance().user!.mobile).png")
        return filePath

    }
    
    func loadImageView(){
        return
        
        let filePath = SignatureViewController.imagePath()
        if NSFileManager.defaultManager().fileExistsAtPath(filePath){
            self.imageView.image = UIImage.init(contentsOfFile: filePath)
            self.imageView.hidden = false
        }else{
            self.imageView.hidden = true
        }
    }
    
    func addSignatureView() {
        let v = self.view
        v.addSubview(self.signView)
        signView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(50)
            make.left.equalTo(v).offset(20/2)
            make.height.equalTo(400)
            make.width.equalTo(v.snp_width).offset(20)
        }
    }
    
    func addLeftBarAction() -> Void {
        let item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = item
    }
    
    func addRightBarAction() -> Void {
        let item = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goNext))
        self.navigationItem.rightBarButtonItem = item
    }

    func addRedrawBtn(){
        let v = self.view
        let btn = redrawBtn
        v.addSubview(btn)
        btn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(v).offset( -50)
            make.height.equalTo(40)
            make.width.equalTo(120)
            make.left.equalTo(v).offset(20)
        }
//        btn.setImage(UIImage.init(named: "redraw"), forState: .Normal)
        btn.setTitle("重绘", forState: .Normal)
        btn.layer.cornerRadius = 15
        btn.titleLabel?.font = UIFont.systemFontOfSize(17)
        btn.backgroundColor = kBaseColor
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.titleLabel?.textAlignment = .Center
        btn.addTarget(self, action: #selector(redraw), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func redraw(){
        self.imageView.hidden = true
        self.imageView.removeFromSuperview()
        self.signView.clearSignature()
    }
    
    func goBack()  {
        KKKRouter.popViewController()
    }
    
    func goNext()  {
        //UIImage
        self.saveImage()
        KKKRouter.goToSignHandAndContract()
    }
    
    func saveImage(){
        imageView.image = self.signView.getSignature()
        let filePath = SignatureViewController.imagePath()
        UIImagePNGRepresentation(imageView.image!)?.writeToFile(filePath, atomically: true)
    }
}
