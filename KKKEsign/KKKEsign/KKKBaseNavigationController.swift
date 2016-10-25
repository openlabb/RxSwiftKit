//
//  KKKBaseNavigationController.swift
//  KKKEsign
//
//  Created by kkwong on 16/10/25.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

class KKKBaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.redColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.yellowColor()
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    
}
