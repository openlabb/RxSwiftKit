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
        HHRouter.shared().map("/hand/",toControllerClass: SignatureViewController.self )
        HHRouter.shared().map("/contractHand/",toControllerClass: ContractSignViewController.self )

    }
    
    class func goToLogin(){
        let viewController = HHRouter.shared().matchController("/login");
        self.pushViewController(viewController)
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
        
        let nav: KKKBaseNavigationController = KKKBaseNavigationController.init(rootViewController: vc)
        appDelegate().window?.rootViewController = nav
        return nav
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
//        let nav: UINavigationController = UINavigationController.init(rootViewController: viewController)
        return viewController
    }
    
    
    class func goBack() {
        self.popViewController()
    }
    
    class func goToFaceOK(){
        let viewController = HHRouter.shared().matchController("/html/");
        let vc: ESignWebViewController = viewController as! ESignWebViewController
        vc.localFileName = "mian_5_2"
        let nav: KKKBaseNavigationController = KKKBaseNavigationController.init(rootViewController: vc)
        appDelegate().window?.rootViewController = nav
    }
    
    class func goToSignHand(){
        let viewController = HHRouter.shared().matchController("/hand/");
        self.pushViewController(viewController)
    }
    
    class func goToSignHandAndContract(){
        let viewController = HHRouter.shared().matchController("/contractHand/");
        self.pushViewController(viewController)
    }
    
    class func goToFace() {
        let viewController = HHRouter.shared().matchController("/faceDetect/");
        self.presentViewController(viewController)
    }
    
    class func goToSMS(){
        let isReceiver:Bool = KKKUserService.shareInstance().userType.value == KKKUserType.KKKUserTypeReceiver
        let viewController = HHRouter.shared().matchController("/html/");
        let vc: ESignWebViewController = viewController as! ESignWebViewController
        vc.localFileName = "x_two"
        if isReceiver {
            vc.localFileName = "x_two2"
        }
        self.pushViewController(vc)
    }
    
    class func goToMain(){
        let viewController = HHRouter.shared().matchController("/html/");
        let vc: ESignWebViewController = viewController as! ESignWebViewController
        vc.localFileName = "mian"
        let nav: KKKBaseNavigationController = KKKBaseNavigationController.init(rootViewController: vc)
        appDelegate().window?.rootViewController = nav
    }
    
    class func popViewController() {
        let topVC = self.topViewController()

        if let nav = topVC?.navigationController {
            nav.popViewControllerAnimated(true)
        } else {
            self.topViewController()?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    class func pushViewController(viewController: UIViewController) {
        let topVC = self.topViewController()
        if let nav = topVC?.navigationController {
            //避免同时多个ViewController加入堆栈
            dispatch_async(dispatch_get_main_queue()) {
                nav.pushViewController(viewController, animated: true)
            }
        }else{
            self.presentViewController(viewController)
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