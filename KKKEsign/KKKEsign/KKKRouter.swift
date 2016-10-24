//
//  KKKRouter.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/13.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import HHRouter
class KKKRouter{
    class func config(){
        HHRouter.shared().map("/user/:userId/",toControllerClass: KKKRegisterViewController.self )
        HHRouter.shared().map("/register/",toControllerClass: KKKRegisterViewController.self )
        HHRouter.shared().map("/login/",toControllerClass: KKKLoginViewController.self )
//        HHRouter.shared().map("/contractList/",toControllerClass: ContractListViewController.self )
//        HHRouter.shared().map("/contract/",toControllerClass: ContractViewController.self )
        HHRouter.shared().map("/faceDetect/",toControllerClass: KKKDectViewController.self )
        HHRouter.shared().map("/html/",toControllerClass: ESignWebViewController.self )
    }
    
    class func goToLogin(){
        let viewController = HHRouter.shared().matchController("/login");
        self.pushViewController(viewController)
    }

    class func goToSignOK(){
        let viewController = HHRouter.shared().matchController("/html/");
        let vc: ESignWebViewController = viewController as! ESignWebViewController
        vc.localFileName = "mian_5_2"
        appDelegate().window?.rootViewController = viewController
    }
    
    
    class func goToRegister() {
        let viewController = HHRouter.shared().matchController("/register/");
        self.pushViewController(viewController)
    }
    
    class func backToHome()->UIViewController{
        let viewController = HHRouter.shared().matchController("/html/");
        let vc: ESignWebViewController = viewController as! ESignWebViewController
        let user:KKKUser? = KKKUserService.shareInstance().user
        print("-----当前登录用户 \(user)")
        switch KKKUserService.shareInstance().userType.value
        {
            case KKKUserType.KKKUserTypeReceiver:
                vc.localFileName = "mian_3_2"
            default:
                vc.localFileName = "userCenter"
        }
        
        appDelegate().window?.rootViewController = viewController
        return viewController
    }
    
    class func rootViewController() -> UIViewController {
        let viewController:UIViewController
//        if KKKUserService.shareInstance().isLogin {
//            let user:KKKUser? = KKKUserService.shareInstance().user
//            print("-----当前登录用户 \(user)")
//            
//           viewController = HHRouter.shared().matchController("/html/")
//            let vc: ESignWebViewController = viewController as! ESignWebViewController
//            switch KKKUserService.shareInstance().userType.value
//            {
//            case KKKUserType.KKKUserTypeReceiver:
//                vc.localFileName = "mian_3_2"
//            default:
//                vc.localFileName = "userCenter"
//            }
//        }else{
//            viewController = HHRouter.shared().matchController("/login");
//        }
        //不管什么时候打开都是登录窗口，For Demo
        viewController = HHRouter.shared().matchController("/login");

        return viewController
    }
    
    
    class func goToWebViewController(urlString:String){
        let viewController = HHRouter.shared().matchController("/html");
        self.pushViewController(viewController)
    }
    
    
    class func goToFace() {
    let viewController = HHRouter.shared().matchController("/faceDetect/");
    self.pushViewController(viewController)

    }
    
    class func goToMain(){
        let viewController = HHRouter.shared().matchController("/html/");
        let vc: ESignWebViewController = viewController as! ESignWebViewController
        vc.localFileName = "mian"
        appDelegate().window?.rootViewController = viewController
    }

    //        let time: NSTimeInterval = 0.0
    //        let delay = dispatch_time(DISPATCH_TIME_NOW,
    //                                  Int64(time * Double(NSEC_PER_SEC)))
    //        dispatch_after(delay, dispatch_get_main_queue()) {
    //            viewController.presentViewController(vc, animated: false, completion: nil)
    //

    
    class func goToContractList(){
        let viewController = HHRouter.shared().matchController("/contractList/");
        self.pushViewController(viewController)
    }

    class func popViewController() {
        if let navigationController = self.topViewController()! as? UINavigationController {
            navigationController.popViewControllerAnimated(true)
        } else {
            self.topViewController()?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    class func pushViewController(viewController: UIViewController) {
        if let navigationController = self.topViewController()! as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
            //避免同时多个ViewController加入堆栈
            dispatch_async(dispatch_get_main_queue()) {
                navigationController.pushViewController(viewController, animated: true)
            }
        }else{
            presentViewController(viewController)
        }
    }
}

extension KKKRouter{
    class  func presentViewController(viewController: UIViewController) {
        let currentVC = self.topViewController()
        let backCurrentVC = currentVC?.presentingViewController
        var toPresent:Bool = false
        if ((backCurrentVC) != nil) {
            let vcClassName: AnyClass = (backCurrentVC!.classForCoder)
            let viewControllerClassName: AnyClass = viewController.classForCoder
            if vcClassName == viewControllerClassName  {
            }else{
                toPresent = true
            }
        }else{
            toPresent = true
        }
        
        if toPresent  {
            dispatch_async(dispatch_get_main_queue()) {
                self.topViewController()!.presentViewController(viewController, animated: false, completion: nil)
            }

        }else{
            currentVC?.dismissViewControllerAnimated(false, completion: {
                
            })
        }
    }

    class  func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }


}