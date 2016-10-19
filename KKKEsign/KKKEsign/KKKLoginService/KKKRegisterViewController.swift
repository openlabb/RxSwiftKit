//
//  File.swift
//  KKKEsign
//
//  Created by kkwong on 16/9/14.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

let kBackColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
let kBaseColor = UIColor.init(red: 48/255.0, green: 141/255.0, blue: 244/255.0, alpha: 1)
let kSecondsStart:Int = 60

class KKKRegisterViewController: UIViewController{
    let logoImageView:UIImageView = UIImageView(image: UIImage.init(named:"logo"))
    let inView:KKKRegisterView = KKKRegisterView()
    let jumpBtn:UIButton = UIButton()
    private var viewModel:KKKLoginViewModel?
    private let disposeBag = DisposeBag()
    var timer:NSTimer?
    var timeRemains = Variable(0)
    
    // MARK: -------Life Cycle
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backColor = kBackColor
        self.view.backgroundColor = backColor
        self.addSubviews()
        self.binding()
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
    
    init(){
        super.init(nibName:nil,bundle:nil)
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
            make.height.equalTo((40+10)*4 + 10)//4个控件,每个高度40,间隔10,底部按钮与上面的间隔为10
        }
        preV = inView
        
        //左下部跳转登录界面
        v.addSubview(jumpBtn)
        jumpBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(v).offset( -10)
            make.left.equalTo(v).offset(kSignViewMarginX)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        jumpBtn.setTitle("直接登录", forState: .Normal)
        jumpBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        jumpBtn.setTitleColor(kBaseColor, forState: .Normal)
        
    }
    
    // MARK: -------VM与V绑定
    func binding()  {
        //绑定:界面输入 驱动－> 本地校验＋网络请求
        self.viewModel =  KKKLoginViewModel(
            input: (
                mobile: inView.mobileV.tf.rx_text.asDriver(),
                password: inView.pwdV.tf.rx_text.asDriver(),
                pin: inView.pinV.tf.rx_text.asDriver(),
                pinTap: inView.pinV.btn.rx_tap.asDriver(),
                actionTap: inView.actionButton.rx_tap.asDriver()
            ),
            dependency: (
                validateServer: ValidateService.shareInstance(),
                networkServer: ValidateService.shareInstance()
            )
        )
        
        //绑定:按钮事件 驱动－>定时器开启
        self.inView.pinV.btn.rx_tap.asDriver().driveNext{
            self.timeRemains.value = kSecondsStart
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,  target: self, selector: #selector(KKKRegisterViewController.updateTimeRemains), userInfo: nil, repeats: true)
            }.addDisposableTo(disposeBag)

        
        //绑定: 定时器&&手机号码有效 驱动－> 界面验证码按钮状态
        let pinBtn:UIButton = self.inView.pinV.btn
        pinBtn.layer.cornerRadius = 3
        
        let clickValid:Driver<Bool> = timeRemains.asDriver().map{ num -> Bool in
            switch num{
            case 0:
                self.timer?.invalidate()
                pinBtn.setTitle("获取验证码", forState:.Normal)
                return true
            default:
                pinBtn.setTitle("\(num)秒重发", forState:.Normal)
                return false
            }
        }
        
        let pinBtnEnable = Driver.combineLatest(self.viewModel!.mobileEnable, clickValid){
            return $0 && $1
            }.distinctUntilChanged()
        pinBtnEnable.drive(pinBtn.rx_requestEnable).addDisposableTo(self.disposeBag)
        
        
        //绑定: 本地校验 位数有效手机号+位数有效验证码+位数有效密码 驱动-> 注册按钮界面状态
        Driver.just(false).drive(self.inView.actionButton.rx_requestEnable).addDisposableTo(self.disposeBag)
        self.viewModel!.actionEnable.distinctUntilChanged().drive(self.inView.actionButton.rx_requestEnable).addDisposableTo(self.disposeBag)
        
        //绑定: 服务器注册API请求结果 驱动-> 界面跳转与否
        self.viewModel?.actionSuccess
            .driveNext({ (ret) in
                if(ret){
                    //跳转--VM中搞定了
                }else{
                    self.inView.pinV.tf.text = ""
                    self.inView.pwdV.tf.text = ""
                }
            }).addDisposableTo(self.disposeBag)

        //绑定: 登录按钮 驱动-> Variable<登录状态>
        self.jumpBtn.rx_tap.asDriver().driveNext{
            self.viewModel?.loginStatus.value = .KKKLoginStatusLogging
            }.addDisposableTo(disposeBag)

    }
    
    func updateTimeRemains(){
        timeRemains.value = timeRemains.value - 1
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


