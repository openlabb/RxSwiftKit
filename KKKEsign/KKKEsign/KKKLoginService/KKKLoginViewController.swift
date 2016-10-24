//
//  KKKLoginViewController.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/17.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class KKKLoginViewController: UIViewController{

    let logoImageView:UIImageView = UIImageView(image: UIImage.init(named:"logo"))
    let inView:KKKLoginInView = KKKLoginInView()
    let jumpBtn:UIButton = UIButton()
    private var viewModel:KKKLoginViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: -------Life Cycle
    
    //单例
    static func shareOne()->KKKLoginViewController{
        struct shareInstance{
            static var onceToken : dispatch_once_t = 0
            static var single:KKKLoginViewController?
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
        self.addSubviews()
        self.binding()
        self.bindingData()
        self.setupForDemo()
    }
    
    func setupForDemo()  {
        self.inView.actionButton.layer.cornerRadius = 20
        Driver.just(true).drive(self.inView.actionButton.rx_requestEnable)
        KKKUserService.shareInstance().userType.asDriver().map { num -> Void in
            switch num{
            case .KKKUserTypeReceiver:
                self.inView.mobileV.tf.text = "15667809876"
                self.inView.pwdV.tf.text = "123456"
                self.jumpBtn.setTitle("切换成发送账号", forState: .Normal)
            case .KKKUserTypeNormal:
                self.inView.mobileV.tf.text = "18756983625"
                self.inView.pwdV.tf.text = "123456"
                self.jumpBtn.setTitle("切换成签收账号", forState: .Normal)
            }
            self.showHint("当前已\((self.jumpBtn.titleLabel?.text)! as String)")
        }.drive().addDisposableTo(self.disposeBag)

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
        self.inView.mobileV.tf.becomeFirstResponder()

        //顶部Logo图
        logoImageView.image = UIImage.init(named: "kkkklogo")
        
        let kSignViewMarginX = 20
        let v = view
        var preV:UIView = v
        v.addSubview(logoImageView)
        logoImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(v).offset(20)
            make.centerX.equalTo(v)
            make.width.equalTo(v)
            make.width.equalTo(logoImageView.snp_height).multipliedBy(1674/888.0)
        }
        preV = logoImageView
        
        //中间注册输入框和按钮
        v.addSubview(inView)
        inView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(preV.snp_bottom).offset(10)
            make.left.equalTo(v).offset(kSignViewMarginX)
            make.right.equalTo(v).offset(-kSignViewMarginX)
            make.height.equalTo((40+10)*3 + 10)//4个控件,每个高度40,间隔10,底部按钮与上面的间隔为10
        }
        preV = inView
        
        //左下部跳转登录界面
        v.addSubview(jumpBtn)
        jumpBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(v).offset( -10)
            make.left.equalTo(v).offset(kSignViewMarginX)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        jumpBtn.setTitle("注   册 ", forState: .Normal)
        jumpBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        jumpBtn.setTitleColor(kBaseColor, forState: .Normal)
        jumpBtn.titleLabel?.textAlignment = .Left
    }
    
    
    // MARK: -------VM与V绑定
    func binding()  {
        //绑定:界面输入 驱动－> 本地校验＋网络请求
        self.viewModel =  KKKLoginViewModel(
            input: (
                mobile: inView.mobileV.tf.rx_text.asDriver(),
                password: inView.pwdV.tf.rx_text.asDriver(),
                actionTap: inView.actionButton.rx_tap.asDriver()
            ),
            dependency: (
                validateServer: ValidateService.shareInstance(),
                networkServer: ValidateService.shareInstance()
            )
        )
        
        
        
        //绑定: 本地校验 位数有效手机号+位数有效验证码+位数有效密码 驱动-> 注册按钮界面状态
        Driver.just(false).drive(self.inView.actionButton.rx_requestEnable).addDisposableTo(self.disposeBag)
        self.viewModel!.actionEnable.distinctUntilChanged().drive(self.inView.actionButton.rx_requestEnable).addDisposableTo(self.disposeBag)
        
        //绑定: 服务器注册API请求结果 驱动-> 界面跳转与否
        self.viewModel?.actionSuccess
            .driveNext({ (ret) in
                if(ret){
                    //跳转-VM中搞定了
                }else{
                    self.inView.pwdV.tf.text = ""
                }
            }).addDisposableTo(self.disposeBag)
        
        //绑定: 注册按钮 驱动-> Variable<登录状态>
        self.jumpBtn.rx_tap.asDriver().driveNext{
//            self.viewModel?.loginStatus.value = .KKKLoginStatusRegistering
            //setupForDemo
            var userType:Int = KKKUserService.shareInstance().userType.value.rawValue
            if userType == 0{
                userType = 1
            }else{
                userType = 0
            }
                KKKUserService.shareInstance().userType.value = KKKUserType(rawValue: userType)!
            }.addDisposableTo(disposeBag)
    }

    // MARK: -------数据绑定
    func bindingData()  {
        let user:KKKUser? = KKKUserService.shareInstance().user
        if user != nil {
            if let mobile = user?.mobile  {
                if mobile.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                    inView.mobileV.tf.text = mobile
                }
            }
        }
    }
    
}


private extension UIButton {
    var rx_requestEnable: AnyObserver<Bool> {
        return UIBindingObserver(UIElement: self, binding: { (button, bool) in
            self.enabled = bool
            if bool {
                self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.backgroundColor = kBaseColor
                self.layer.borderWidth = 0
            }else{
                self.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                self.backgroundColor = kBackColor
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.lightGrayColor().CGColor
            }
        }).asObserver()
    }
}


