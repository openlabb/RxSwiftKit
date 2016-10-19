//
//  KKKUserService.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/15.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class KKKUserService{

    static let instance = KKKUserService()
    
    class func shareInstance() -> KKKUserService {
        return self.instance
    }
    
    //当前用户
    var user:KKKUser?{
        set{
            if newValue != nil {
                KKKUserService.shareInstance().isLogin = true
            }
            Defaults[.user] = newValue
        }
        get{
            
            if Defaults[.user] != nil {
                return Defaults[.user]
            }
            return nil
        }
    }
    
    //当前用户是否登录
    var isLogin: Bool {
        set{
            Defaults[.isLogged] = true
        }
        get{
//            Defaults.removeAll()
            if Defaults[.isLogged] == nil {
                return false
            }
            return Defaults[.isLogged]!
        }

    }
    
    class func newUserID() -> Int{
        let user = KKKUserService.shareInstance().user
        if (user != nil) {
            return (user?.id)!+1
        }else{
            return 0
        }
    }
    
    
}
