//
//  Items.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/9.
//  Copyright © 2016年 kkwong. All rights reserved.
//


import Argo
import Curry

//对于无须返回数据的API接口用KKKResponse来对接,使其符合Argo的转换规则
struct KKKBlankResponse {
    let placeholder:String
}

extension KKKBlankResponse: Decodable {
    static func decode(json: JSON) -> Decoded<KKKBlankResponse> {
        return curry(KKKBlankResponse.init)
            <^> json <| "data"
    }
}


struct KKKUser {
    let id: Int
    let mobile: String
    let password: String
    let avatar: String
//    let url: String
    
    //这段代码是为了把结构体存到UserDefaults中，参考http://swiftandpainless.com/nscoding-and-swift-structs/
    static func encode(user: KKKUser) {
        let userClassObject = HelperClass(user: user)
        NSKeyedArchiver.archiveRootObject(userClassObject, toFile: HelperClass.path())
    }
    
    static func decode() -> KKKUser? {
        let userClassObject = NSKeyedUnarchiver.unarchiveObjectWithFile(HelperClass.path()) as? HelperClass
        return userClassObject?.user
    }
}

extension KKKUser: Decodable {
    static func decode(json: JSON) -> Decoded<KKKUser> {
        return curry(KKKUser.init)
            <^> json <| "id"
            <*> json <| "mobile"
            <*> json <| "password"
            <*> json <| "avatar"
    }
    
}


extension KKKUser {
    class HelperClass: NSObject, NSCoding {
        
        var user: KKKUser?
        
        init(user: KKKUser) {
            self.user = user
            super.init()
        }
        
        class func path() -> String {
            let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
            let path = documentsPath?.stringByAppendingString("/user")
            return path!
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard let mobile = aDecoder.decodeObjectForKey("mobile") as? String else {
                user = nil;
                super.init();
                return nil
            }
            
            guard let iD = aDecoder.decodeObjectForKey("id") as? Int else {
                user = nil;
                super.init();
                return nil
            }
            
            let password = aDecoder.decodeObjectForKey("password") as! String
            let avatar = aDecoder.decodeObjectForKey("avatar") as! String
            user = KKKUser(id: iD, mobile: mobile, password: password, avatar: avatar)
            super.init()
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(user!.id, forKey: "id")
            aCoder.encodeObject(user!.mobile,forKey:"mobile")
            aCoder.encodeObject(user!.password,forKey:"password")
            aCoder.encodeObject(user!.avatar,forKey:"avatar")
        }
    }
}



