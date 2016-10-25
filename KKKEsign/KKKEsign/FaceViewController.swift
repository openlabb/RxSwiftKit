//
//  FaceViewController.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/24.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

class FaceViewController:KKKWebPlugin{
    func goDetect()  {
        KKKRouter.goToFace()
    }
    
    func goLogin()  {
        KKKRouter.goToLogin()
    }
    
    func goSignHand()  {
        KKKRouter.goToSignHand()
    }
    
    func goBack()  {
        KKKRouter.goBack()
    }

    
    
    class func deleteFaceGID() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey("faceGID")
        userDefault.synchronize()
    }

    
}