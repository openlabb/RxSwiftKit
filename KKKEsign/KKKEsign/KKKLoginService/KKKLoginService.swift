//
//  KKKLoginService.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/12.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import RxSwift

final class SingleTwo {
    //单例
    // 这里用static 换掉 Class
    static func shareSingleTwo()->SingleTwo{
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:SingleTwo?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single=shareSingleTwo()
            }
        )
        return Singleton.single!
    }
    private init(){}
}




class KKKLoginService {
    
    static let shareInstance = KKKLoginService()
    
//    let loginStatus = Variable(0)

    var userId: String?
    
    var isLogin: Bool {
        return userId != nil
    }
    
    private let disposeBag = DisposeBag()

    init() {
//        self.loginStatus.asDriver().map{num -> Void in
//            switch num{
//                case 0:
//                    KKKRouter.goToLogin()
//                case 1:
//                    KKKRouter.goToRegister()
//            default: break
////                UIApplication.sharedApplication().window
//            }
//        }.drive().addDisposableTo(self.disposeBag)
        
    }
    
    
    
    static func login() {
        
    }
    
}
