//
//  KKKLoginView.swift
//  KKKEsign
//
//  Created by kkwong on 16/9/14.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation

public enum KKKLoginViewType:Int {
    case KKKLoginViewTypeSignUp//注册
    case KKKLoginViewTypeSignIn//登录
    case KKKLoginViewTypePWDReset//找回密码
}


class KKKSignUpView: KKKSignBaseView {
    var mobileV:lableTextField = lableTextField(title: "手机号", hint: "请输入11位手机号")
    var pinV:lableTextFieldButton = lableTextFieldButton(title: "验证码", hint: "4位验证码", btnName: "获取验证码")
    var pwdV:lableTextField = lableTextField(title: "密码", hint: "6位密码")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(){
        super.init(frame: CGRectZero)
        let views = [mobileV,pinV,pwdV,actionButton]
        self.addSubviews(views)
        actionButton.setTitle("注      册", forState: .Normal)
    }
    

}

class KKKSignInView: KKKSignBaseView {
    var mobileV:iconTextField = iconTextField(imageName: "手机号", hint: "请输入11位手机号")
    var pwdV:iconTextField = iconTextField(imageName: "密码", hint: "6位密码")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(){
        super.init(frame: CGRectZero)
        let views = [mobileV,pwdV,actionButton]
        self.addSubviews(views)
        actionButton.setTitle("登      录", forState: .Normal)

    }

}

class KKKPasswordResetView: KKKSignBaseView {

    var mobileV:lableTextField = lableTextField(title: "手机号", hint: "请输入11位手机号")
    var pinV:lableTextFieldButton = lableTextFieldButton(title: "验证码", hint: "4位验证码", btnName: "获取验证码")

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(){
        super.init(frame: CGRectZero)
        let views = [mobileV,pinV,actionButton]
        self.addSubviews(views)
        actionButton.setTitle("确      定", forState: .Normal)
    }
}

class KKKSignBaseView: UIView {
    var kItemHeight = 40
    var actionButton:UIButton = UIButton()
    var actionHinter:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func addSubviews(items:Array<UIView>) {
        let baseView = UIView()
        baseView.backgroundColor = UIColor.whiteColor()
        baseView.layer.cornerRadius = 3
        baseView.clipsToBounds = false
        self.addSubview(baseView)
        baseView.snp_makeConstraints { (make) in
            make.left.top.width.equalTo(self)
            make.height.equalTo(self).offset(-55)
        }
        
        let v = baseView
        var preV:UIView = items[0]
        for item in items {
            v.addSubview(item)
            item.snp_makeConstraints { (make) in
                var offset = 0
                if(items.indexOf(item) == items.count-1){
                    offset = 1
                    make.top.equalTo(preV.snp_bottom).offset(50)
                }else if(items.indexOf(item) == 0){
                    make.top.equalTo(v)
                }else{
                    make.top.equalTo(preV.snp_bottom)
                }
                make.left.equalTo(v).offset(offset)
                make.right.equalTo(v).offset(-offset)
                make.height.equalTo(kItemHeight)
                
            }
            preV = item
        }
        actionButton.backgroundColor = kBaseColor
        actionButton.layer.cornerRadius = 3
        actionButton.titleLabel?.textColor = UIColor.whiteColor()
        actionButton.titleLabel?.font = UIFont.systemFontOfSize(14)
    }

}

class lableTextField:UIView{
    let kTextFieldMarginTop = 20
    let kTextFieldMarginLeft = 20
    let kLabelWidth = 60
    let kLabelHight = 40
    
    var lbl :UILabel = UILabel()
    var tf:UITextField = UITextField()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(title:String,hint:String){
        super.init(frame: CGRectZero)
        lbl.text = title
        lbl.textColor = UIColor.grayColor()
        lbl.font = UIFont.systemFontOfSize(13)
        tf.placeholder = hint
        tf.clearButtonMode = .WhileEditing
        tf.textAlignment = .Left
        tf.textColor = UIColor.blackColor()
        tf.font = UIFont.systemFontOfSize(14)
        self.addSubviews()
    }
    
    func addSubviews() {
        let v = self
        
        self.addSubview(lbl)
        lbl.snp_makeConstraints { (make) in
            make.top.equalTo(v).offset(kTextFieldMarginTop)
            make.left.equalTo(v).offset(kTextFieldMarginLeft)
            make.width.equalTo(kLabelWidth)
            make.height.equalTo(kLabelHight)
        }
        
        self.addSubview(tf)
        tf.snp_makeConstraints { (make) in
            make.top.equalTo(v).offset(kTextFieldMarginTop)
            make.left.equalTo(lbl.snp_right)
            make.right.equalTo(v).offset(-kTextFieldMarginLeft)
            make.height.equalTo(kLabelHight)//lable与textfield等高
        }
    }
    
}


class iconTextField:UIView{
    let kTextFieldMarginTop = 20
    let kTextFieldMarginLeft = 20
    let kIconWidth = 40
    let kIconHight = 40
    
    var icon :UIImageView = UIImageView()
    var tf:UITextField = UITextField()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(imageName:String,hint:String){
        super.init(frame: CGRectZero)
        icon.image = UIImage.init(named: imageName)
        tf.placeholder = hint
        tf.clearButtonMode = .WhileEditing
        tf.textAlignment = .Left
        tf.textColor = UIColor.blackColor()
        tf.font = UIFont.systemFontOfSize(14)
        self.addSubviews()
    }
    
    func addSubviews() {
        let v = self
        
        self.addSubview(icon)
        icon.snp_makeConstraints { (make) in
            make.top.equalTo(v).offset(kTextFieldMarginTop)
            make.left.equalTo(v).offset(kTextFieldMarginLeft)
            make.width.equalTo(kIconWidth)
            make.height.equalTo(kIconWidth)
        }
        
        self.addSubview(tf)
        tf.snp_makeConstraints { (make) in
            make.top.equalTo(v).offset(kTextFieldMarginTop)
            make.left.equalTo(icon.snp_right)
            make.right.equalTo(v).offset(-kTextFieldMarginLeft)
            make.height.equalTo(kIconHight)//icon与textfield等高
        }
    }
    
}


class lableTextFieldButton:UIView{
    let kTextFieldMarginTop = 20
    let kTextFieldMarginLeft = 20
    let kLabelWidth = 60
    let kLabelHight = 40
    let kButtonWidth = 80
    
    var lbl :UILabel = UILabel()
    var tf:UITextField = UITextField()
    var btn:UIButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(title:String,hint:String,btnName:String){
        super.init(frame: CGRectZero)
        lbl.text = title
        lbl.textColor = UIColor.grayColor()
        lbl.font = UIFont.systemFontOfSize(13)
        tf.placeholder = hint
        tf.clearButtonMode = .WhileEditing
        tf.textAlignment = .Left
        tf.textColor = UIColor.blackColor()
        tf.font = UIFont.systemFontOfSize(14)
        btn.setTitle(btnName, forState: .Normal)
        btn.setTitle(btnName, forState: .Highlighted)
        btn.titleLabel!.font = UIFont.systemFontOfSize(13)
        btn.setTitleColor(kBaseColor, forState: .Normal)
        self.addSubviews()
    }
    
    func addSubviews() {
        let v = self
        
        self.addSubview(lbl)
        lbl.snp_makeConstraints { (make) in
            make.top.equalTo(v).offset(kTextFieldMarginTop)
            make.left.equalTo(v).offset(kTextFieldMarginLeft)
            make.width.equalTo(kLabelWidth)
            make.height.equalTo(kLabelHight)
        }
        
        self.addSubview(btn)
        btn.snp_makeConstraints { (make) in
            make.top.equalTo(v).offset(kTextFieldMarginTop)
            make.right.equalTo(v).offset(-kTextFieldMarginLeft)
            make.width.equalTo(kButtonWidth)
            make.height.equalTo(kLabelHight)
        }

        
        self.addSubview(tf)
        tf.snp_makeConstraints { (make) in
            make.top.equalTo(v).offset(kTextFieldMarginTop)
            make.left.equalTo(lbl.snp_right)
            make.right.equalTo(btn.snp_left)
            make.height.equalTo(kLabelHight)//lable与textfield等高
        }
    }
    
}

