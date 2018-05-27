//
//  MMLoginInputView.swift
//  myApp
//
//  Created by user1 on 2017/6/20.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import UIKit

protocol MMLoginInputProtocol : NSObjectProtocol {
    
    func loginInputViewDidTouchNormalControl(_ :MMLoginInputView)
    func loginInputViewDidTouchSelectControl(_ :MMLoginInputView)
    func loginInputViewDidInputChange(_ :MMLoginInputView)
}

typealias MMVoidCallBack = ()->Void
typealias MMStringCallBack = (_ text:String)->Void
typealias MMIntCallBack = (_ index:Int)->Void
/// 对登录界面上的输入框进行封装的类 ，提供block和代理两种方式进行回调
class MMLoginInputView: UIView {

    open var lineView = UIView()// open : swift的`访问控制`语义，表示在工程中都可以访问
    open var inputTextField = UITextField()
    open var controlButton = UIButton()

    open var bReturnHandle : MMVoidCallBack?
    weak open var delegate: MMLoginInputProtocol?
    
    open var inputText:String?{// 计算属性，只有getter方法，所有这个是只读属性
        get{
            return self.inputTextField.text
        }
    }
    private var haveControlButton = false// 是有需要有右边的控制按键
    
    fileprivate var displayLabel = UILabel()// fileprivate :swift3.0新增的`访问控制`语义，表示文件内私有
    private var bNormalHandle : MMVoidCallBack?// private :swift的`访问控制`语义，表示类或者结构体内私有，离开了改作用域就不能访问
    private var bSelectHandle : MMVoidCallBack?
    private var bInputDidChangeHandle : MMStringCallBack?

    // `init?` 失败构造器，这是因为下面有一句代码返回了一个nil
    public init(placeholder:String?,controlNormal:String?,controlSelect:String?) {
        
        super.init(frame: CGRect.zero)
        
        //
        displayLabel.textColor = UIColor(red:0.49, green:0.49, blue:0.49, alpha:1.00)
        displayLabel.font = UIFont.systemFont(ofSize: 12)
        displayLabel.backgroundColor = UIColor.clear
        displayLabel.alpha = 0.0
        self.addSubview(displayLabel)
        
        //
        lineView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        self.addSubview(lineView)
        
        //
        inputTextField.font = UIFont.systemFont(ofSize: 14)
        inputTextField.textColor = UIColor.black
        inputTextField.tintColor = UIColor(red:0.25, green:0.75, blue:0.32, alpha:1.00)
        inputTextField.clearButtonMode = .whileEditing
        inputTextField.backgroundColor = UIColor.clear
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(inputTextFieldDidChangeContent), for: .editingChanged)
        self.addSubview(inputTextField)
        
        //
        controlButton.backgroundColor = UIColor.clear
        controlButton.addTarget(self, action: #selector(controlButtonHandle(button:)), for: .touchUpInside)
        self.addSubview(controlButton)
        
        let isNull = (controlNormal == nil) && (controlSelect == nil)
        if !isNull {
            let isEmpty = ((controlNormal?.isEmpty)!) && ((controlSelect?.isEmpty)!)
            self.haveControlButton = !(isNull || isEmpty)
        }
        self.config(placeholder: placeholder, controlNormal: controlNormal, controlSelect: controlSelect)
    }
    
    // 便利初始化方法
    convenience init(placeholder:String) {// 只有一个inputTextField，没有右边的控制按键
        self.init(placeholder: placeholder, controlNormal: nil, controlSelect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(1/UIScreen.main.scale)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        displayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(20)
        }
        
        controlButton.snp.makeConstraints { (make) in
            let size = (self.haveControlButton ? CGSize.init(width: 20, height: 20) : CGSize.zero)
            make.size.equalTo(size)
            make.right.equalTo(self.snp.right)
            make.centerY.equalTo(inputTextField.snp.centerY)
        }
        
        inputTextField.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            let offset = (self.haveControlButton ? -10 : 0)
            make.right.equalTo(controlButton.snp.left).offset(offset)// 三目运算符要和条件有空格，不然容易被编译器理解为可选类型
            make.top.equalTo(self.displayLabel.snp.bottom)
            make.bottom.equalTo(lineView.snp.top)
        }
    }
    
    //MARK: - API M
    func config(normalHandle:MMVoidCallBack?,selectHandle:MMVoidCallBack?,inputDidChange:MMStringCallBack?){

        bNormalHandle = normalHandle
        bSelectHandle = selectHandle
        bInputDidChangeHandle = inputDidChange
    }
    /**
     置为初始状态
     */
    func resetControlState(text:String = ""){
    
        if "" != text {
            self.updateInputText(text: text)
        }
        self.inputTextFieldDidChangeContent(textField: self.inputTextField)
        self.inputTextField.resignFirstResponder()
    }
    /**
     进入编辑状态
     */
    func becomeInputState() {
        if !self.inputTextField.isFirstResponder {
            self.inputTextField.becomeFirstResponder()
        }
    }
    /**
     更新输入框内容
     */
    func updateInputText(text:String?){
    
        inputTextField.text = text!
    }
    /**
     配置视图的显示
     */
    @objc private func config(placeholder:String?,controlNormal:String?,controlSelect:String?) {
        
        displayLabel.text = placeholder
        inputTextField.attributedPlaceholder = NSAttributedString.init(string: placeholder!, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)])
        
        if nil != controlNormal {
            let normalImage = UIImage.init(named: controlNormal!)
            controlButton.setImage(normalImage, for: .normal)
        }
        if nil != controlSelect {
            let selectImage = UIImage.init(named: controlSelect!)
            controlButton.setImage(selectImage, for: .selected)
        }
    
    }
    // MARK - Action M
    @objc private func controlButtonHandle(button:UIButton?){
        
        if (button?.isSelected)! {
            
            if (nil != bSelectHandle) {
                bSelectHandle!()
            } else{
                self.delegate?.loginInputViewDidTouchSelectControl(self)
            }
        }else{
            if (nil != bNormalHandle) {
                bNormalHandle!()
            } else{
                self.delegate?.loginInputViewDidTouchNormalControl(self)
            }
        }
        button?.isSelected = !(button?.isSelected)!
    }
    
    // 在target-action模式下，编译器提示需要加上@objc，然后由于这是内部的控件点击事件，可以把它设置成为fileprivate、private，来降低访问权限
    @objc fileprivate func inputTextFieldDidChangeContent(textField:UITextField?){
    
        if (nil != bInputDidChangeHandle) {
            bInputDidChangeHandle!((textField?.text)!)
        }else{
            self.delegate?.loginInputViewDidInputChange(self)
        }
        
        if ((textField?.text) == nil || textField?.text == "") {
            UIView.animate(withDuration: 0.2, animations: { 
                self.displayLabel.alpha = 0.0
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.displayLabel.alpha = 1.0
            })
        }
    }
    
    // 访问权限
    // 区别见下
    fileprivate func foo(){}
    private func bar(){}
    
    open func macg(){}
    public func oop(){}
    internal func doop(){}
    private(set) var privateName : String?
    // 默认属性的getter和setter都是internal的，使用private(set/get)、internal(get/set)可以降低对应的访问权限
    // 上面的例子的意思是 
    // privateName属性只能在定义该结构体或者类的源文件中赋值，其余地方不能进行赋值
    // 不过，由于swift3.0之后新增了fileprivate来替换原来的private，现在private的意思就是绝对的私有，见下
    // 所以，如果可以的话或者某不清private和fileprivate的区别，写成fileprivate(set/get)会比较好一些，这样在分类中也可以进行修改
}

class User {
    fileprivate var fakePrivateName = "fakePrivateName"
    private var privateName = "privateName"
    internal var internalName = "internalName"
    public var publicName = "publicName"
    open var openName = "openName"
    
    var mmModel : MMOpenClass?
    
}

extension User{
    func oop(){
        
        _ = self.openName
        _ = self.internalName
        _ = self.publicName
        _ = self.fakePrivateName // 这里可以访问 fakePrivateName
        //_ = self.privateName // 这里不能访问 privateName 属性，因为他的访问权限为private
    }
}
class SubUser:User{

    func bor() {
        _ = self.openName
        _ = self.internalName
        _ = self.publicName
        _ = self.fakePrivateName // 这里可以访问 fakePrivateName
        //_ = self.privateName // 这里不能访问 privateName 属性，因为他的访问权限为private
    }
}

// 显式的申明 MMPrivateClass 为一个private类，在这个文件外部是不能够使用的
private class MMPrivateClass : NSObject{

    var user = User()
    func testUser() {
        
        if (user.mmModel?.age) != nil {
            
        }
    }
    var name : String?// 隐式的、private访问权限
    public var age : Int?
    internal var address : String?
    open var school : String?
}

fileprivate class MMFilePrivateClass : NSObject{

    var user = User()
    func testUser() {
        
        if (user.mmModel?.age) != nil {
            
        }
    }
    var name : String?// 隐式的、private访问权限
    public var age : Int?
    internal var address : String?
    open var school : String?
}

class MMInternalClass : NSObject{

    var name : String?// 隐式的、internal访问权限
    public var age : Int?
    internal var address : String?
    open var school : String?
}

public class MMPublicClass : NSObject{

    var name : String?// 隐式的、public访问权限
    public var age : Int?// 显式的、public
    private var address : String?// 显式的private
    open func bar(){}
}

open class MMOpenClass : NSObject{
    
    var name : String?// 隐式的、private访问权限
    public var age : Int?
    internal var address : String?
    func bar(){}
    public func poo(){}
    internal func oop(){}
    fileprivate func abc(){}
    private func def(){}
    
    open var school : String?{
        
        get{
            return self.school
        }
        set{
            if (newValue?.isEmpty)! {
                print("newValue is null")
            }
        }
    }
    subscript(index:Int)->Int{// 下标脚本写法
        return age! * index
    }
}
// 上面的都快看懵逼了，但是记住一点：那就是你要确保新类型的访问级别和它实际的作用域相匹配
extension MMLoginInputView :UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let privateObj = MMPrivateClass()// 在MMPrivateClass 的作用域范围内，可以使用
        privateObj.name = "rocky"
        privateObj.school = "hpu"
        privateObj.age = 12
        privateObj.address = "henan"
        
        let openObj = MMOpenClass()
        openObj.age = 12
        let result = openObj[2]
        print(result)
        
        _ = MMFilePrivateClass()
        _ = MMPublicClass()
        
        // test 控制访问权限
        _ = self.privateName
        
        // open 针对于模块： 其他模块中可以 被访问 可以 被override
        // public 针对于模块： 其他模块中只能 被访问 不能 被继承
        
        // 这就是 open产生的初衷。通过open和public标记区别一个元素在其他module中是只能被访问还是可以被override。
        self.foo()// fileprivate    该类或者结构体以外则不能调用，做到了改类或者结构体内私有
//        self.bar()// private 在这里不可以调用 bar函数，该类或者结构体以外则更加不能调用，做到了真正私有！！！！
        self.macg()// open 在这里可以调用o macg函数，并且在其他地方也可以通过该类或者结构体调用这个函数
        self.oop()// public 在这里可以调用 oop函数，并且在其他地方也可以通过该类或者结构体调用这个函数
        self.doop()// internal 默认的访问控制级别，可以访问自己模块或应用中源文件里的任何实体，但是别人不能访问该模块中源文件里的实体
        textField.resignFirstResponder()
        if nil != bReturnHandle {
            bReturnHandle!()
        }
        return true
    }
}
