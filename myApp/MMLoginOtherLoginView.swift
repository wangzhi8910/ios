//
//  MMLoginOtherLoginView.swift
//  myApp
//
//  Created by user1 on 2017/6/20.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import UIKit

/// 其他登录方式，使用xib构建
class MMLoginOtherLoginView: UIView {

    @IBOutlet weak var wechatLoginButton: UIButton!
    @IBOutlet weak var qqLoginButton: UIButton!
    
    @IBOutlet weak var wechatDisplayLabel: UILabel!
    @IBOutlet weak var qqDisplayLabel: UILabel!
    
    @IBOutlet weak var wechatWidthConstraint: NSLayoutConstraint!
    
    class func viewFromNib()->MMLoginOtherLoginView{
    
        return Bundle.main.loadNibNamed("MMAccountMgrView", owner: nil, options: nil)?.first as! MMLoginOtherLoginView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.wechatDisplayLabel.backgroundColor = UIColor.clear
        self.qqDisplayLabel.backgroundColor = UIColor.clear
        
        self.showAllTwoButton()
    }
    
    /**
     API M
     */
    open func showAllTwoButton(){
        wechatWidthConstraint.constant = 0;
        self.qqLoginButton.isHidden = false
        self.qqDisplayLabel.isHidden = false
        
        self.wechatLoginButton.isHidden = false
        self.wechatDisplayLabel.isHidden = false
    }
    open func showOnlyWechatButton(){
        let screenWidth = self.bounds.width
        wechatWidthConstraint.constant = screenWidth/2;
        self.qqLoginButton.isHidden = true
        self.qqDisplayLabel.isHidden = true
        
        self.wechatLoginButton.isHidden = false
        self.wechatDisplayLabel.isHidden = false
    }
    open func showOnlyQQButton(){
        let screenWidth = self.bounds.width
        wechatWidthConstraint.constant = -screenWidth/2;
        self.qqLoginButton.isHidden = false
        self.qqDisplayLabel.isHidden = false
        
        self.wechatLoginButton.isHidden = true
        self.wechatDisplayLabel.isHidden = true
    }
    @IBAction func qqButtonHandle(_ sender: Any) {
        
    }
    @IBAction func wechatButtonHandle(_ sender: UIButton) {
        
    }
}
