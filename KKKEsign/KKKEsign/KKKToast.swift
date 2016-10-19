//
//  AppInfo.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/11.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import Toast_Swift

class KKKToast{
    static func showToast(message: String?, duration: NSTimeInterval = 2) {
        UIApplication.sharedApplication().keyWindow?.makeToast(message!, duration: duration, position:.Center)
    }
}


