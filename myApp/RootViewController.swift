//
//  RootViewController.swift
//  myApp
//
//  Created by wangzhi on 17/4/10.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        
        let delay = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: delay) {// swift中GCD的after异步执行，传递的时间是一个DispatchTime对象
           self.navigationController?.dismiss(animated:true, completion: nil)
        }
    }
    
    
}


