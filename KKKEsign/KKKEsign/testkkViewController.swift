//
//  testkkViewController.swift
//  KKKEsign
//
//  Created by kkwong on 16/9/21.
//  Copyright © 2016年 kkwong. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class testkkViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var textfield: UITextField!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        testkk()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func testEmpty()  {
        
    }
    func testkk() {
        textfield.rx_text.asDriver().distinctUntilChanged().drive{
            print("kkkkk")
        }.addDisposableTo(disposeBag)
//
        textfield.rx_text.asDriver().drive{ (text) -> Void in
            print("2kkkkk\(text)")
            }.addDisposableTo(disposeBag)


        
        textfield.rx_text.asDriver().distinctUntilChanged().map{
            $0.characters.count > 3
        }.drive()
        
//        textfield.rx_text.asDriver().driveNext { [weak self] aa in
//            print(aa)
//            self?.testEmpty()
//return
//            }.addDisposableTo(disposeBag)
//
//        
//        textfield.rx_text.asDriver().distinctUntilChanged().map{
//            $0.characters.count > 3
//            }.drive{
//                
//        }.addDisposableTo(disposeBag)
        
        //        let mobileValidator = input.mobile.asDriver()
        //            .distinctUntilChanged()
        //            .map {
        //        这里不被激活不知道为什么,改用下面的方式
        //                return dependency.validateServer.validateMobile($0) }
        //

    }
    
}

