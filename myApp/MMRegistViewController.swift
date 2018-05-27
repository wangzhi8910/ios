//
//  MMRegistViewController.swift
//  myApp
//
//  Created by user1 on 2017/6/21.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import UIKit

/**
 *   用来验证是否可以进行注册下一步的数据结构
 */
struct MMRegistValidViewModel {
    
    var phoneNumber : String = ""// 声明phoneNumber属性是Stirng类型的，并且其初始值为 ""
    var isRegistValid : Bool {// 只读的计算属性，使用正则来判断电话号码是否合法
        get{
            // 测试结构体初始化
            _ = MMSampleRegex.init(.Default(.Phone))// 使用内置的Phone来初始化一个正则匹配对象
            _ = MMSampleRegex.init(.Custom("32rewf"))// 使用自定义的字符串来初始化一个正则匹配对象
            _ = MMSampleRegex.init("sfefsd")// 常规的使用字符串初始化一个正则匹配对象
            
            let matcher = MMSampleRegex(.Default(.Phone))
            return (matcher?.match(self.phoneNumber))!
        }
    }
    var safeNextFlag = true// 防止多次点击下一步按钮导致的问题
}

class MMRegistViewController: UIViewController {

    let logoView = MMLoginLogoView()
    let nextButotn = MMThemeButton.init(title: "下一步")
    let phoneInputView = MMLoginInputView.init(placeholder: "请输入手机号码")
    
    var validRegist = MMRegistValidViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 
        self.view.addSubview(self.logoView)
    
        //
        phoneInputView.inputTextField.keyboardType = .phonePad
        phoneInputView.config(normalHandle: nil, selectHandle: nil) { text in// 这里text可以不用写类型，编译器会推断出来他是String类型
            self.validRegist.phoneNumber = text
            self.updateNextButton()
        }
        self.view.addSubview(self.phoneInputView)
        
        // 
        nextButotn.addTarget(self, action: #selector(nextButtonHandle(_:)), for: .touchUpInside)
        self.view.addSubview(self.nextButotn)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.validRegist.safeNextFlag = true// 当每次进入界面的时候重置flag
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let margin = 40
        
        logoView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(194)
        }
        
        phoneInputView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.height.equalTo(50)
            make.top.equalTo(self.logoView.snp.bottom).offset(10)
        })
        
        nextButotn.snp.makeConstraints { (make) in
            make.left.equalTo(self.phoneInputView)
            make.right.equalTo(self.phoneInputView)
            make.height.equalTo(40)
            make.top.equalTo(self.phoneInputView.snp.bottom).offset(30)
        }
    }
    
    private func updateNextButton() {
        
        self.nextButotn.isEnabled = self.validRegist.isRegistValid
    }
    
    @objc private func nextButtonHandle(_ button:UIButton){
    
        if self.validRegist.safeNextFlag {
            print("next step")
            self.navigationController?.pushViewController(UIViewController(), animated: true)
            self.validRegist.safeNextFlag = false
        }
    }
}

/**
 *  一个简单的正则匹配结构体，用于根据正则规则、接收数据来判断是否可以正确匹配  可以抽出来方便移植
 
 目前改结构体的局限性：如果要匹配的是手机号和邮箱的话，就不能使用` | `符号来进行位操作
 
 想了一个折中的方法，分别初始化两个判断的regex实例，然后根据match结果进行需要的` || `、` && `操作
 */
public struct MMSampleRegex {
    
    /**
     内置的几种匹配规则
     */
    enum MMPatternType{
        // 枚举是可以嵌套的，这里由于默认值枚举不能有参数，所以这使用一个枚举(MMPatternDefaultType)成为另一个枚举(MMPatternType)的选项
        enum MMPatternDefaultType : String{
            
            case Phone  = "^((13[0-9])|(147)|(15[0-3,5-9])|(18[0,0-9])|(17[0-3,5-9]))\\d{8}$"
            case Email  = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            case IP     = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            case ID     = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
        }
        case Custom(String) // 默认值枚举不能有参数！！
        case Default(MMPatternDefaultType)
    }
    
    let regex: NSRegularExpression?
    
    /**
     通过`内置的几种正则表达式`创建结构体
     */
    init?(_ patternType : MMPatternType) {
        
        switch patternType {
        case let .Custom(text):
            self.init(text)
        case let .Default(defaultType):
            self.init(defaultType.rawValue)
        }
    }
    
    /**
     通过`字符串正则表达式`创建结构体
     */
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
