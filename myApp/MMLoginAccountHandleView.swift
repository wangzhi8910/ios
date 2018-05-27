//
//  MMLoginAccountHandleView.swift
//  myApp
//
//  Created by user1 on 2017/6/20.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import UIKit

protocol MMLoginAccountHandleViewProtocol :NSObjectProtocol {

    func accountHandleViewDidLogin(_ : MMLoginAccountHandleView)
    func accountHandleViewDidRegist(_ : MMLoginAccountHandleView)
    func accountHandleViewDidForgetPassword(_ : MMLoginAccountHandleView)
}

/// 登录、注册以及忘记密码功能模块，使用代理进行事件回调
class MMLoginAccountHandleView: UIView {

    struct MMSafeAccountFlags{
        
        var safeLoginFlag = true
        var safeRegistFlag = true
        var safeForgetPasswordFlag = true
    }

    weak open var delegate : MMLoginAccountHandleViewProtocol?
    
    open var loginButton = MMThemeButton.init(title: "登录")
    open var registButton = UIButton.init(type: UIButtonType.custom)
    open var forgetPsdButton = UIButton.init(type: UIButtonType.custom)
    
    private var linView = UIView()
    private var safeFlag = MMSafeAccountFlags()
    
    init() {
        super.init(frame: CGRect.zero)
    
        self.backgroundColor = UIColor.clear
        
        //
        loginButton.addTarget(self, action: #selector(loginButtonHandle(_:)), for: .touchUpInside)
        self.addSubview(loginButton)
        
        //
        registButton.setTitleColor(UIColor(red:0.25, green:0.75, blue:0.32, alpha:1.00), for: .normal)
        registButton.setTitle("3秒注册", for: .normal)
        registButton.addTarget(self, action: #selector(registButtonHandle(_:)), for: .touchUpInside)
        registButton.titleLabel?.font = UIFont.italicSystemFont(ofSize: 14)
        self.addSubview(registButton)
        
        //
        forgetPsdButton.setTitleColor(UIColor(red:0.49, green:0.49, blue:0.49, alpha:1.00), for: .normal)
        forgetPsdButton.setTitle("忘记密码", for: .normal)
        forgetPsdButton.addTarget(self, action: #selector(forgetPasswordHandle(_:)), for: .touchUpInside)
        forgetPsdButton.titleLabel?.font = UIFont.italicSystemFont(ofSize: 14)
        self.addSubview(forgetPsdButton)
        
        //
        linView.backgroundColor = UIColor(red:0.49, green:0.49, blue:0.49, alpha:1.00)
        self.addSubview(linView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        loginButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.top.equalToSuperview()
            make.left.equalTo(0)
            make.right.equalToSuperview().offset(-0)
        }
        
        linView.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(30)
            make.height.equalTo(17)
            make.centerX.equalTo(loginButton.snp.centerX)
            make.width.equalTo(2/UIScreen.main.scale)
        }
        
        registButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(30)
            make.centerY.equalTo(linView)
            make.right.equalTo(linView.snp.left).offset(0)
        }
        
        forgetPsdButton.snp.makeConstraints { (make) in
            make.width.equalTo(registButton)
            make.height.equalTo(registButton)
            make.centerY.equalTo(linView)
            make.left.equalTo(linView.snp.right).offset(0)
        }
    }
    
    // MARK: - API M
    public func activateLoginButton() {
        self.loginButton.isEnabled = true
    }
    public func freezeLoginButton() {
        self.loginButton.isEnabled = false
    }
    
    // MARK: - 防止多次重复点击按钮的操作
    public func resetLoginFlag(){
        self.safeFlag.safeLoginFlag = true
    }
    public func resetRegistFlag(){
        self.safeFlag.safeRegistFlag = true
    }
    public func resetForgetPasswordFlag(){
        self.safeFlag.safeForgetPasswordFlag = true
    }
    
    // MARK: - Action M
    @objc private func loginButtonHandle(_ button:UIButton?) {
        if self.safeFlag.safeLoginFlag {
            self.delegate?.accountHandleViewDidLogin(self)
            self.safeFlag.safeLoginFlag = false
        }
    }
    
    @objc private func registButtonHandle(_ button:UIButton?) {
        if self.safeFlag.safeRegistFlag {
            self.delegate?.accountHandleViewDidRegist(self)
            self.safeFlag.safeRegistFlag = false
        }
    }
    
    @objc private func forgetPasswordHandle(_ button:UIButton?) {
        if self.safeFlag.safeForgetPasswordFlag {
            self.delegate?.accountHandleViewDidForgetPassword(self)
            self.safeFlag.safeForgetPasswordFlag = false
        }
    }
}

open class MMThemeButton : UIButton{

    init(title:String) {

        super.init(frame: CGRect.zero)

        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.gray, for: .disabled)
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.isEnabled = false// 默认是不可以点击
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .disabled)
        self.setBackgroundImage(UIImage.init(named: "MM_login_normal_login_bg"), for: .normal)
        self.setBackgroundImage(UIImage.init(named: "MM_login_disable_login_bg"), for: .disabled)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
