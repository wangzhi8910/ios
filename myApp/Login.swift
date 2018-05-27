//
//  Login.swift
//  myApp
//
//  Created by wangzhi on 17/4/17.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

struct MMLoginValidViewModel {
    
    var name = ""
    var password = ""
    
    func isValid()->Bool{
        
        let nameValid : Bool = !(name.isEmpty)
        let passwordValid : Bool = (!(password.isEmpty)) &&
            (6 <= (password.characters.count)) &&
            ((password.characters.count) <= 14)
        return nameValid && passwordValid
    }
    
}

class Login: UIViewController {
    
    var logoImageView = UIImageView.init(image: UIImage.init(named: "MM_login_mask_img"))
    var userNameInputView : MMLoginInputView?
    var userPsdInputView : MMLoginInputView?
    var otherLoginView : MMLoginOtherLoginView?
    
    open var validLogin = MMLoginValidViewModel()
    
    var accountHandleView : MMLoginAccountHandleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // logo
        self.view.addSubview(self.logoImageView)
        
        // 输入名称
        userNameInputView = MMLoginInputView.init(placeholder: "请输入手机号/么么号", controlNormal: "MM_login_arrow_down", controlSelect: "MM_login_arrow_up")
        userNameInputView?.inputTextField.keyboardType = .phonePad
        userNameInputView!.config(normalHandle: {
        
        }, selectHandle: {
            
        }, inputDidChange: {name in
            print("input is :" + name)
            self.validLogin.name = name
            self.updateAccountHandleView()
        })
        userNameInputView!.resetControlState()
        userNameInputView!.bReturnHandle? = {
            self.userPsdInputView!.becomeInputState()
        }
        // 输入密码
        userPsdInputView = MMLoginInputView.init(placeholder: "请输入密码(6-14位)", controlNormal: "MM_login_eyes_close", controlSelect: "MM_login_eyes_open")
        userPsdInputView!.inputTextField.isSecureTextEntry = true
        userPsdInputView!.config(normalHandle: {
            self.userPsdInputView!.inputTextField.isSecureTextEntry = false
        }, selectHandle: {
            self.userPsdInputView!.inputTextField.isSecureTextEntry = true
        }, inputDidChange: {password in
            print("input is :" + password)
            self.validLogin.password = password
            self.updateAccountHandleView()
        })
        
        // 登录、注册视图
        accountHandleView = MMLoginAccountHandleView()
        accountHandleView?.delegate = self
        
        // 其他登录方式
        otherLoginView = MMLoginOtherLoginView.viewFromNib()
        
        self.view.addSubview(self.userNameInputView!)
        self.view.addSubview(self.userPsdInputView!)
        self.view.addSubview(self.accountHandleView!)
        self.view.addSubview(self.otherLoginView!)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let margin = 40
        
        logoImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(194)
        }
        userNameInputView!.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.height.equalTo(50)
            make.top.equalTo(self.logoImageView.snp.bottom).offset(10)
        }
        userPsdInputView!.snp.makeConstraints { (make) in
            make.left.equalTo(userNameInputView!.snp.left)
            make.right.equalTo(userNameInputView!.snp.right)
            make.height.equalTo(userNameInputView!.snp.height)
            make.top.equalTo(userNameInputView!.snp.bottom).offset(10)
        }
        
        accountHandleView!.snp.makeConstraints({ (make) in
            make.top.equalTo(self.userPsdInputView!.snp.bottom).offset(20)
            make.left.equalTo(self.userPsdInputView!)
            make.right.equalTo(self.userPsdInputView!)
            make.height.equalTo(100)
        })
        
        otherLoginView!.snp.makeConstraints({ (make) in
            make.left.equalTo(self.accountHandleView!)
            make.bottom.equalTo(0)
            make.right.equalTo(self.accountHandleView!)
            make.height.equalTo(120)
        })
    }
    
    func updateAccountHandleView() {
        
        if (self.validLogin.isValid()) {
            self.accountHandleView?.activateLoginButton()
        }else{
            self.accountHandleView?.freezeLoginButton()
        }
    }
}
extension Login :UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension Login :UITableViewDataSource{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
}

// MARK: - 隐藏键盘的操作
extension Login {
    
    func loginViewResignFirstResponder() {
        self.userNameInputView?.resetControlState()
        self.userPsdInputView?.resetControlState()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        self.loginViewResignFirstResponder()
    }
}

extension Login: MMLoginAccountHandleViewProtocol{

    func accountHandleViewDidLogin(_ handleView : MMLoginAccountHandleView){
        print("login handle")
        self.loginViewResignFirstResponder()
    }
    func accountHandleViewDidRegist(_ handleView : MMLoginAccountHandleView){
        print("regist handle")
        self.loginViewResignFirstResponder()
    }
    func accountHandleViewDidForgetPassword(_ handleView : MMLoginAccountHandleView){
        print("forget handle")
        self.loginViewResignFirstResponder()
    }
}
