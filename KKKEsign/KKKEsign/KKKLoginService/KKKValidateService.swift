//
//  KKKViewModelServer.swift
//  KKKEsign
//
//  Created by kkwong on 16/9/15.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

enum ValidateResult {
    case succeed
    case failed(message: String)
    case empty
}

infix operator ^-^ {}
func ^-^ (lhs: ValidateResult, rhs: ValidateResult) -> Bool {
    switch (lhs, rhs) {
    case  (.succeed, .succeed):
        return true
    default:
        return false
    }
}

class ValidateService{

    static let instance = ValidateService()
    
    class func shareInstance() -> ValidateService {
        return self.instance
    }
    
    let mobileCountValid :Int = 11
    let passwordCountValid :Int = 6
    let pinCountValid :Int = 4

    
    func validateMobile(mobile:String) -> ValidateResult {
        guard let x = Int(mobile) where (x / 10000000000) == 1 else{
            return .failed(message:"请输入正确的手机号码")
        }
        return mobile.characters.count == self.mobileCountValid ? .succeed : .failed(message:"请输入11位手机号码")
    }
    
    func validatePassword(password:String) -> ValidateResult {
        return password.characters.count >= self.passwordCountValid ? .succeed : .failed(message:"请输入正确的密码")
    }
    
    func validatePIN(pin:String) -> ValidateResult {
        return pin.characters.count >= self.pinCountValid ? .succeed : .failed(message:"请输入4位验证码")
    }

}