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

class KKKLoginViewModel{
    
//    let loginEnable:Driver<Bool>
//    init(input:(mobile:Driver<String>,password:Driver<String>,pin:Driver<String>,actionTap:Driver<Void>),dependency:(validateServer:ValidateServer,networkServer:NetWorkServer)){
//        let mobileValidator = input.mobile.skip(1)
//        .distinctUntilChanged()
//            .map{
//                return dependency.validateServer.validatePassword($0)
//        }
//        
//        let passwordValidator =  input.password.skip(1)
//            .distinctUntilChanged()
//            .map{
//                return dependency.validateServer.validatePassword($0)
//        }
//        
//        let pinValidator =  input.password.skip(1)
//            .distinctUntilChanged()
//            .map{
//                return dependency.validateServer.validatePIN($0)
//        }
//
//        let mobileAndPasswordAndPIN = Driver.combineLatest(input.mobile, input.password, input.pin){
//            ($0,$1,$2)
//        }
//        
//        
//        
//    }
    
}