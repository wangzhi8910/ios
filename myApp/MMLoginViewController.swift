//
//  MMLoginViewController.swift
//  myApp
//
//  Created by user1 on 2017/6/21.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import UIKit
import SnapKit// 引入SnapKit包，在程序的其他地方就不需要再引入

// 用来封装是否可以登录的数据结构。结构体一般用于比较简单的数据结构
struct MMLoginValidViewModel {
    
    var name = ""// 存储属性，可set可get
    var password = ""
    
    // 使用函数来计算是否可以登录
    func isValid()->Bool{
        
        // 没有使用正则判断合法性
        let nameValid : Bool = !(name.isEmpty)
        let passwordValid : Bool = (!(password.isEmpty)) &&
            (6 <= (password.characters.count)) &&
            ((password.characters.count) <= 14)
        return nameValid && passwordValid
    }
    // 还可以使用计算属性，设置一个只读的计算属性
    var isLoginValid : Bool {
        
        get{
            // 使用正则来判断输入是否合法
            var nameValid :Bool
            let phoneValid = MMSampleRegex.init(.Default(.Phone))?.match(self.name)
            let mmNubValid = MMSampleRegex.init(.Custom("^[0-9]{2,10}$"))?.match(self.name)// 么么号至少为2位,最多为10位
            let passwordValid = MMSampleRegex.init("^[a-zA-Z0-9]{6,14}$").match(self.password)// [6,14]位的密码
            
            nameValid = phoneValid! || mmNubValid!
            return nameValid && passwordValid
        }
    }
}

class MMOpenSubClass: MMOpenClass {
    
    override func bar(){}
    override func poo(){}
    override func oop(){}
    open func abc(){}
    func def(){}
}

class MMLoginViewController: UIViewController {
    
    let logoView = MMLoginLogoView()
    let userNameInputView : MMLoginInputView = {// 通过闭包和函数来设置属性的默认值
        let nameInputView = MMLoginInputView.init(placeholder: "请输入手机号/么么号", controlNormal: "MM_login_arrow_down", controlSelect: "MM_login_arrow_up")
        nameInputView.inputTextField.keyboardType = .phonePad
        nameInputView.resetControlState()
        
        //_ = MMPrivateClass()// 出了MMPrivateClass 类的作用域范围就不可以再使用了
        _ = MMOpenClass()
        
        //_ = MMFilePrivateClass() // 出了MMFilePrivateClass 类的作用域范围，不可以使用
        _ = MMPublicClass()
        _ = MMInternalClass()
        
        
        // test 控制访问权限
        //nameInputView.foo()   // fileprivate
        //nameInputView.bar()   // private
        nameInputView.macg()    // open
        nameInputView.oop()     // public
        nameInputView.doop()    // internal
        _ = nameInputView.privateName
        
        
        return nameInputView
    }()// 这个类似于js中的立即执行函数
    
    //可选链式 调用是一种可以在当前值可能为nil的可选值上请求和调用属性、方法及下标的方法。如果可选值有值，那么调用就会成功；如果可选值是nil，那么调用将返回nil。多个调用可以连接在一起形成一个调用链，如果其中任何一个节点为nil，整个调用链都会失败，即返回nil
    
    //它们的主要区别在于当可选值为空时可选链式调用只会调用失败，然而强制展开将会触发运行时错误。 ? 和 ！区别
    var userPsdInputView : MMLoginInputView?// 未初始化，所以是`？`默认为nil
    var otherLoginView : MMLoginOtherLoginView?
    var accountListView : MMLoginAccountListView?
    
    //现在的访问权限则依次为：open，public，internal，fileprivate，private。
    //区别：http://www.jianshu.com/p/604305a61e57
    open var validLogin = MMLoginValidViewModel()// 这是一个结构体，不能设置成let，不然其中的属性就不可以修改
    
    let logoImageView = UIImageView.init(image: UIImage.init(named: "MM_login_mask_img"))
    
    let accountHandleView = MMLoginAccountHandleView()
    
    //相当于OC的dealloc
    deinit{
        print("MMLoginViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //validLogin.isLoginValid = false// 由于validLogin.isLoginValid 是一个只读的计算属性，所以这里不能够为其设置新值
        
        // logo
        self.view.addSubview(self.logoView)
        
        //此外你还可以使用 unowned 关键字替换掉 weak,那么两者的区别在哪里？倘若你使用 weak,属性可以是可选类型，即允许有 nil 值的情况。另一方面，倘若你使用 unowned，它不允许设为可选类型。因为一个 unowned 属性不能为可选类型，那么它必须在 init 方法中初始化值：
        userNameInputView.config(normalHandle: { [unowned self] () -> Void in
            
            if (self.accountListView?.containAccount())!{
                UIView.animate(withDuration: 0.3, animations: {
                    self.accountListView?.alpha = 1.0
                })
            }
            }, selectHandle: { [unowned self] () -> Void in
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.accountListView?.alpha = 0.0
                })
            }, inputDidChange: { [unowned self]  name in
                
                self.validLogin.name = name
                self.updateAccountHandleView()
        })
        
        userNameInputView.bReturnHandle? = {
            self.userNameInputView.resetControlState()
        }
        // 输入密码
        userPsdInputView = MMLoginInputView.init(placeholder: "请输入密码(6-14位)", controlNormal: "MM_login_eyes_close", controlSelect: "MM_login_eyes_open")
        userPsdInputView!.inputTextField.isSecureTextEntry = true
        userPsdInputView!.config(normalHandle: { [unowned self] () -> Void in
            self.userPsdInputView!.inputTextField.isSecureTextEntry = false
            }, selectHandle: { [unowned self] () -> Void in
                self.userPsdInputView!.inputTextField.isSecureTextEntry = true
            }, inputDidChange: { [unowned self] password in
                self.validLogin.password = password
                self.updateAccountHandleView()
        })
        
        // 登录、注册和忘记密码视图
        accountHandleView.delegate = self
        
        // 其他登录方式
        otherLoginView = MMLoginOtherLoginView.viewFromNib()
        
        // 账户列表视图
        accountListView = MMLoginAccountListView()
        accountListView?.delegate = self
        accountListView?.alpha = 0.0
        
        self.view.addSubview(self.userNameInputView)
        self.view.addSubview(self.userPsdInputView!)
        self.view.addSubview(self.accountHandleView)
        self.view.addSubview(self.otherLoginView!)
        self.view.addSubview(self.accountListView!)
    }
    
    // 1、init初始化不会触发layoutSubviews
    // 2、addSubview会触发layoutSubviews
    // 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
    // 4、滚动一个UIScrollView会触发layoutSubviews
    // 5、旋转Screen会触发父UIView上的layoutSubviews事件
    // 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let margin = 40
        
        logoView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(194)
        }
        
        userNameInputView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.height.equalTo(50)
            make.top.equalTo(self.logoView.snp.bottom).offset(10)
        }
        userPsdInputView!.snp.makeConstraints { (make) in
            make.left.equalTo(userNameInputView.snp.left)
            make.right.equalTo(userNameInputView.snp.right)
            make.height.equalTo(userNameInputView.snp.height)
            make.top.equalTo(userNameInputView.snp.bottom).offset(10)
        }
        
        accountHandleView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.userPsdInputView!.snp.bottom).offset(20)
            make.left.equalTo(self.userPsdInputView!)
            make.right.equalTo(self.userPsdInputView!)
            make.height.equalTo(100)
        })
        
        otherLoginView!.snp.makeConstraints({ (make) in
            make.left.equalTo(self.accountHandleView)
            make.bottom.equalTo(0)
            make.right.equalTo(self.accountHandleView)
            make.height.equalTo(120)
        })
        
        accountListView!.snp.makeConstraints { (make) in
            make.left.equalTo(self.userNameInputView)
            make.right.equalTo(self.userNameInputView)
            make.bottom.equalTo(self.otherLoginView!)
            make.top.equalTo(self.userNameInputView.snp.bottom)
        }
        UIApplication.shared.keyWindow!.rootViewController = MMMainTabBarController()
        
    }
    
    func updateAccountHandleView() {
        
        if (self.validLogin.isLoginValid) {
            self.accountHandleView.activateLoginButton()
        }else{
            self.accountHandleView.freezeLoginButton()
        }
    }
}

// MARK: - 隐藏键盘的操作
extension MMLoginViewController {
    
    func loginViewResignFirstResponder() {
        self.userNameInputView.resetControlState()
        self.userPsdInputView?.resetControlState()
        self.accountListViewDoestContainAccount(self.accountListView!)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        self.loginViewResignFirstResponder()
    }
}

extension MMLoginViewController: MMLoginAccountHandleViewProtocol{
    
    func accountHandleViewDidLogin(_ handleView : MMLoginAccountHandleView){
        print("login handle")
        self.loginViewResignFirstResponder()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //.login(userName:"18061996260", password:"wz8910" )
        userProvider.request(.updateUserInfo(token:"e479739aef2634aa9c067d16379618c7")) { result in
            switch result {
            case .success(_):
                do {
                    let rp = try result.dematerialize()
                    let value = try rp.mapString()
                    let model = TTResultModel<TTUserModel>.deserialize(from: value)
                    if model?.code == successCode{
                        
                    } else{
                        //TODO:提示显示
                    }
                } catch{
                    
                }
                
                
                
                break
            // do something with the response data or statusCode
            case let .failure(error):
                
                break
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
            }
        }
        
        // 模拟请求
        let delay = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: delay) {// swift中GCD的after异步执行，传递的时间是一个DispatchTime对象
            self.accountHandleView.resetLoginFlag()
            let alert = UIAlertController.init(title:nil, message: "登录成功", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: {(action)in
                
                // 存储数据
                let account = MMAccountModel.init(self.userNameInputView.inputText, and: self.userPsdInputView?.inputText)
                self.accountListView?.add(account)
            }))
            self.present(alert, animated: true, completion: nil)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        
        
    }
    func accountHandleViewDidRegist(_ handleView : MMLoginAccountHandleView){
        print("regist handle")
        self.present(MMRegistViewController(), animated: true) {
            self.loginViewResignFirstResponder()
        }
    }
    func accountHandleViewDidForgetPassword(_ handleView : MMLoginAccountHandleView){
        print("forget handle")
        self.loginViewResignFirstResponder()
    }
}

extension MMLoginViewController : MMLoginAccountListViewDelegate{
    func accountListViewDoestContainAccount(_ listView: MMLoginAccountListView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            listView.alpha = 0.0
            self.userNameInputView.controlButton.isSelected = false
        })
    }
    func accountListView(_ listView:MMLoginAccountListView, didChooseAccount model:MMAccountModel){
        
        UIView.animate(withDuration: 0.3, animations: {
            listView.alpha = 0.0
            self.userNameInputView.resetControlState(text: model.name!)
            self.userNameInputView.controlButton.isSelected = false
            self.userPsdInputView?.resetControlState(text: model.password!)
        }, completion: {(finished : Bool) in
            self.accountHandleViewDidLogin(self.accountHandleView)
        })
    }
}

