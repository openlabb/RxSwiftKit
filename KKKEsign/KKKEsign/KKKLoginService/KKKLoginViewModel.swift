//
//  KKKLoginViewModel.swift
//  KKKEsign
//
//  Created by kkwong on 16/9/15.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum KKKLoginStatus:Int {
    //默认
    case KKKLoginStatusDefalt
    //已登录
    case KKKLoginStatusLogged
    //登录中
    case KKKLoginStatusLogging
    //注册中
    case KKKLoginStatusRegistering
    //找回密码
    case KKKLoginStatusResetPassword
    
}


class KKKLoginViewModel{
    
    // MARK: - Output
    let mobileEnable: Driver<Bool>
    let actionEnable: Driver<Bool>
    let actionSuccess: Driver<Bool>
    let loginStatus = Variable(KKKLoginStatus.KKKLoginStatusDefalt)
    
    private let disposeBag = DisposeBag()
    
    var shouldVerify:Driver<Bool>?
    
    // MARK: ----------------------------状态跳转
    func bindJump() {
        self.loginStatus.asDriver().map{num -> Void in
            switch num{
            case .KKKLoginStatusLogging:
                //跳到登录窗口
                KKKRouter.goToLogin()
                
            case .KKKLoginStatusRegistering:
                //跳到注册窗口
                KKKRouter.goToRegister()
            case .KKKLoginStatusLogged:
                //跳到主窗口
                KKKRouter.backToHome()
                //写用户信息
                
            default: break
                //                UIApplication.sharedApplication().window
            }
            }.drive().addDisposableTo(self.disposeBag)
        
    }

    // MARK: ----------------------------登录
    
    init(input:(
        mobile:Driver<String>
        ,password:Driver<String>
        ,actionTap:Driver<Void>
        )
        ,
         dependency:(
        validateServer:ValidateService
        ,networkServer:ValidateService)
        ){
        
        // MARK: -------本地校验
        //手机号码个数校验
        let mobileValidator = input.mobile
            .distinctUntilChanged()
            .map {
                return dependency.validateServer.validateMobile($0)
        }
        self.mobileEnable = mobileValidator.flatMapLatest{ result in
            return Driver.just(result ^-^ ValidateResult.succeed)
        }
        
        
        //密码个数校验
        let passwordValidator =  input.password
            .skip(1)
            .distinctUntilChanged()
            .map{
                return dependency.validateServer.validatePassword($0)
        }
        
        //各输入条件都满足就可以走下一步
        self.actionEnable = [mobileValidator,passwordValidator].combineLatest{result -> Bool in
            return (result[0] ^-^ result[1])
        }
        
        
        
        //发送登录请求
        let mobilePinPassword = Driver.combineLatest(input.mobile,input.password){($0, $1)}
        self.actionSuccess = input.actionTap.withLatestFrom(mobilePinPassword)
            .flatMapLatest{
                return KKKEsignAPI.login($0, password: $1)
            }.distinctUntilChanged()
        
        self.actionSuccess.driveNext({ (ret) in
            if(ret){
                //跳转
                self.loginStatus.value = KKKLoginStatus.KKKLoginStatusLogged
            }else{
                //
            }
        }).addDisposableTo(self.disposeBag)
        
        self.bindJump()
    }
    //
    // MARK: ----------------------------注册
    init(input:(
        mobile:Driver<String>
        ,password:Driver<String>
        ,pin:Driver<String>
        ,pinTap:Driver<Void>
        ,actionTap:Driver<Void>
        )
        ,
         dependency:(
        validateServer:ValidateService
        ,networkServer:ValidateService)
        ){
        
        // MARK: -------本地校验
        //手机号码个数校验
        let mobileValidator = input.mobile
            .distinctUntilChanged()
            .map {
                return dependency.validateServer.validateMobile($0)
        }
        self.mobileEnable = mobileValidator.flatMapLatest{ result in
            return Driver.just(result ^-^ ValidateResult.succeed)
        }
        
        //验证码个数校验
        let pinValidator = input.pin
            .skip(1)
            .distinctUntilChanged()
            .map{
                return dependency.validateServer.validatePIN($0)
        }
        
        //密码个数校验
        let passwordValidator =  input.password
            .skip(1)
            .distinctUntilChanged()
            .map{
                return dependency.validateServer.validatePassword($0)
        }
        
        //各输入条件都满足就可以走下一步
        self.actionEnable = [mobileValidator,passwordValidator,pinValidator].combineLatest{result -> Bool in
            return (result[0] ^-^ result[1]) &&  (result[1] ^-^ result[2])
        }
        
        // MARK: -------服务器请求
        //发送获取验证码请求
        input.pinTap.withLatestFrom(input.mobile)
            .flatMapLatest{
                return KKKEsignAPI.requestPIN($0)
            }
            .map{
                if $0 {KKKToast.showToast("验证码已发送")}
            }
            .drive()
            .addDisposableTo(disposeBag)
        
        
        //发送注册请求
        let mobilePinPassword = Driver.combineLatest(input.mobile,input.pin,input.password){($0, $1,$2)}
        self.actionSuccess = input.actionTap.withLatestFrom(mobilePinPassword)
            .flatMapLatest{
                return KKKEsignAPI.register($0, PIN: $1, password: $2)
            }.distinctUntilChanged()
        
        self.actionSuccess.driveNext({ (ret) in
            if(ret){
                //跳转
                self.loginStatus.value = KKKLoginStatus.KKKLoginStatusLogged
            }else{
                //
            }
        }).addDisposableTo(self.disposeBag)
        
        self.bindJump()
        
        
        //        input.pinTap.driveNext{ [weak self] _ in
        //            guard let strongSelf = self else { return }
        //
        //            //            let number = Int((self?.numberLabel.text)!)
        //            //            self?.numberLabel.text = String(number!+1)
        //            } .addDisposableTo(disposeBag)
        //
    }
    
    
    func testkk()->Driver<Int>{
        return Driver.just(1)
    }
    
}