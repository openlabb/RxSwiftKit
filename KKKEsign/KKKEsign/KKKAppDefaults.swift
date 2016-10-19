//
//  KKKAppDefaults.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/19.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension NSUserDefaults {
    subscript(key: DefaultsKey<KKKUser?>) -> KKKUser? {
        get {
//            return unarchive(key)
            return KKKUser.decode()
        }
        set {
            KKKUser.encode(newValue!)
//            archive(key, newValue)
        }
    }
}

extension DefaultsKeys {
    //当前用户
    static let user = DefaultsKey<KKKUser?>("user")
    //是否登录
    static let isLogged = DefaultsKey<Bool?>("isLogged")
    //是否第一次
    static let isLaunched = DefaultsKey<Bool?>("isLaunched")
}

