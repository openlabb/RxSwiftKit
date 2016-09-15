//
//  File.swift
//  KKKEsign
//
//  Created by kkwong on 16/9/14.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

let kBackColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
let kBaseColor = UIColor.init(red: 248/255.0, green: 144/255.0, blue: 34/255.0, alpha: 1)


class KKKSignUpViewController: UIViewController{
    let logoImageView:UIImageView = UIImageView(image: UIImage.init(named:"logo"))
    let signView:KKKSignUpView = KKKSignUpView()
    let signInBtn:UIButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backColor = kBackColor
        self.view.backgroundColor = backColor
        self.addSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(){
        super.init(nibName:nil,bundle:nil)
    }
    
    func addSubviews()  {
        logoImageView.image = UIImage.init(named: "kkkklogo")
        
        let kSignViewMarginX = 20
        let v = view
        var preV:UIView = v
        v.addSubview(logoImageView)
        logoImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(v).offset(20)
            make.centerX.equalTo(v)
            make.width.equalTo(v)
            make.width.equalTo(logoImageView.snp_height).multipliedBy(1674/888.0)
        }
        preV = logoImageView
        
        v.addSubview(signView)
        signView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(preV.snp_bottom).offset(10)
            make.left.equalTo(v).offset(kSignViewMarginX)
            make.right.equalTo(v).offset(-kSignViewMarginX)
            make.height.equalTo(200)
        }
        preV = signView
        
        v.addSubview(signInBtn)
        signInBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(v).offset( -10)
            make.left.equalTo(v).offset(kSignViewMarginX)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        signInBtn.setTitle("直接登录", forState: .Normal)
        signInBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        signInBtn.setTitleColor(kBaseColor, forState: .Normal)
    }

}