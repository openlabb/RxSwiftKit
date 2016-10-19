//
//  KKKEsignAPI.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/9.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Argo
import RxCocoa
import SwiftyUserDefaults

//public let eSignProvider: RxMoyaProvider = RxMoyaProvider<KKKEsignAPI>(stubClosure: MoyaProvider.ImmediatelyStub)
public let eSignProvider: RxMoyaProvider = RxMoyaProvider<KKKEsignAPI>(plugins: [NetworkLoggerPlugin(verbose: true)],stubClosure: MoyaProvider.ImmediatelyStub)

private var disposeBag = DisposeBag()


enum KKKEsignAPI {
    case RequestPIN(String)
    case Register(String,String,String)
    case VerifyPIN(String,String)
    case Login(String,String)
    case ContractsList
    case User(String)
    //    case ContractDetail(contractID:String)
    //    case ESign
}

extension KKKEsignAPI : TargetType{
    var path:String{
        switch self {
        case .RequestPIN(_):
            return "requestpin"
        case .Register(_,_,_):
            return "register"
        case .Login(_,_):
            return "login"
        case .VerifyPIN(_,_):
            return "verifypin"
        case ContractsList:
            return "contractsList"
        case .User(let userID):
            return "user/\(userID)"
        }
    }
    var base:String {
        return "http://www.baidu.com"
    }
    var baseURL:NSURL {
        return NSURL(string:base)!
    }
    
    var parameters:[String:AnyObject]?{
        switch self {
        case .RequestPIN(let mobile):
            return ["mobile":mobile]
        case .Register(let mobile, let PIN, let password):
            return ["mobile":mobile,"pin":PIN,"password":password]
        case .Login(let mobile,let password):
            return ["mobile":mobile,"password":password]
        case .VerifyPIN(let mobile,let PIN):
            return ["mobile":mobile,"pin":PIN]
        case .User(_):
            return nil
        default:
            return nil
        }
    }
    
    var method:Moya.Method{
        switch self {
        case .RequestPIN(_):
            return .POST
        case .Register(_,_,_):
            return .POST
        case .Login(_,_):
            return .POST
        case .VerifyPIN(_,_):
            return .POST
        default:
            return .GET
        }
    }
    
    var sampleData:NSData{
        switch self {
        case .RequestPIN(_):
            return stubbedResponse("pin")
        case .Register(_,_,_):
            return stubbedResponse("KKKpin")
        case .Login(_, _):
//            return stubbedResponse("KKK\(mobile)")
            return stubbedResponse("KKK13241327921")
        default:
            return stubbedResponse("XAuth")
        }
    }

    //    var multipartBody: [Moya.MultipartFormData]? {
    //        return nil
    //    }
    //
    //    var isMultipartUpload: Bool{
    //        return false
    //    }
    //
    
}

extension KKKEsignAPI{
    static func requestPIN(mobile: String) -> Driver<Bool>{
        return eSignProvider.request(.RequestPIN(mobile))
            .mapSuccessfulHTTPToObject(KKKBlankResponse)
            .map{ _ in
                return true
            }.asDriver(onErrorRecover: { (error) -> Driver<Bool> in
                let err:ORMError = error as! ORMError
                var ret:Bool = false
                switch err{
                    case .ORMNotValidData(let message,_):
                        print("------\(message)")
                    case .ORMNoData:
                        ret = true
                    default:
                        print("------\(err)")
                }
                return Driver.of(ret)
            })
    }
    
    static func register(mobile:String,PIN:String,password:String) -> Driver<Bool>{
        return eSignProvider.request(.Register(mobile, PIN, password))
            .mapSuccessfulHTTPToObject(KKKBlankResponse)
            .map{ _ in
                return true
            }.asDriver(onErrorRecover: { (error) -> Driver<Bool> in
                let err:ORMError = error as! ORMError
                var ret:Bool = false
                switch err{
                case .ORMNotValidData(let message,_):
                    print("------\(message)")
                case .ORMNoData:
                    ret = true
                    KKKUserService.shareInstance().user =  KKKUser(id:KKKUserService.newUserID(),mobile: mobile,password: password,avatar: "")
                default:
                    print("------\(err)")
                }
                return Driver.of(ret)
            })
    }
    
    
    static func login(mobile:String,password:String) -> Driver<Bool>{
        return eSignProvider.request(.Login(mobile, password))
            .mapSuccessfulHTTPToObject(KKKUser)
            .map{ _ in
                return true
            }.asDriver(onErrorRecover: { (error) -> Driver<Bool> in
                let err:ORMError = error as! ORMError
                var ret:Bool = false
                switch err{
                case .ORMNotValidData(let message,_):
                    print("------\(message)")
                case .ORMNoData:
                    ret = true
                    KKKUserService.shareInstance().user =  KKKUser(id:KKKUserService.newUserID(),mobile: mobile,password: password,avatar: "")
                default:
                    print("------\(err)")
                }
                return Driver.of(ret)
            })
    }


    static func requestPIN(mobile: String, completion: String -> Void,  fail: ErrorType -> Void) {
        //disposeBag = DisposeBag()
        eSignProvider.request(.RequestPIN(mobile))
            .mapSuccessfulHTTPToObject(String)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { items in
                    completion(items)
                }, onError: { error in
                    fail(error)
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    static func verifyPIN(mobile: String,pin: String, completion: String -> Void,fail: ErrorType -> Void) {
        //disposeBag = DisposeBag()
        eSignProvider.request(.VerifyPIN(mobile,pin))
            .mapSuccessfulHTTPToObject(String)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { items in
                    completion(items)
                }, onError: { error in
                    fail(error)
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    static func login(mobile: String,password: String, completion: KKKUser -> Void) {
        //disposeBag = DisposeBag()
        eSignProvider.request(.Login(mobile,password))
            .mapSuccessfulHTTPToObject(KKKUser)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { items in
                    completion(items)
                }
            )
            .addDisposableTo(disposeBag)
    }


    
    
}



// MARK: - Provider support


func stubbedResponse(filename: String) -> NSData! {
    @objc class TestClass: NSObject { }
    let bundle = NSBundle(forClass: TestClass.self)
    let path = bundle.pathForResource(filename, ofType: "json")
    return NSData(contentsOfFile: path!)
}
