//
//  MMLoginAccountListView.swift
//  myApp
//
//  Created by user1 on 2017/6/21.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import UIKit

class MMAccountModel: NSObject {
    
    var name : String?
    var icon : String?
    var password : String?
    
    var _id : Int?
    
    init(_ name:String? ,and password :String?) {
        
        self.name = name
        self.password = password
        self.icon = "MM_default_user_icon"
        self._id = 8855
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        
        if let otherAccountModel = object{
            return (self.name == (otherAccountModel as AnyObject).name)
        }
        return super.isEqual(object)
    }
}

//protocol MMLoginAccountListViewDelegate : NSObjectProtocol {// 一般的协议写法，这样写，里面的方法都是必须实现
@objc protocol MMLoginAccountListViewDelegate : NSObjectProtocol {// 可以对方法进行必须和可选实现的选择

    @objc optional func accountListView(_ listView:MMLoginAccountListView, didRemoveAccountAt index:Int)// 可选实现的方法
    func accountListView(_ listView:MMLoginAccountListView, didChooseAccount model:MMAccountModel)
    func accountListViewDoestContainAccount(_ listView:MMLoginAccountListView)
}

/// 可以选择账户功能的视图
class MMLoginAccountListView: UIView {

    var accountTableView = UITableView.init(frame: CGRect.zero, style: .plain)
    var accountList : Array<MMAccountModel>?
    
    weak open var delegate : MMLoginAccountListViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        
        //
        accountList = Array()
        
        //
        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.separatorStyle = .none
        accountTableView.tableFooterView = UIView()
        accountTableView.tableHeaderView = UIView()
        accountTableView.register(MMLoginAccountCell.self, forCellReuseIdentifier: MMLoginAccountCell.cellIdentifier())
        self.addSubview(accountTableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accountTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /**
     添加一个账户 如果名称相同，默认为同一个账户，不进行添加
     */
    public func add(_ account:MMAccountModel?){
        guard let accountModel = account else {
            return
        }
        if !(self.accountList?.contains(account!))! {
            
            self.accountList?.append(accountModel)
            self.accountTableView.reloadData()
        }
    }
    
    public func containAccount()->Bool{
    
        return self.accountList?.count != 0
    }
}

extension MMLoginAccountListView :UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.accountListView(self, didChooseAccount: (self.accountList?[indexPath.row])!)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MMLoginAccountListView :UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MMLoginAccountCell.cellIdentifier()) as! MMLoginAccountCell
        cell.configWith((self.accountList?[indexPath.row])!)
        cell.bRemoveHandle = {
            self.accountList?.remove(at: indexPath.row)
            self.delegate?.accountListView!(self, didRemoveAccountAt: indexPath.row)
            tableView.reloadData()
            if 0 == self.accountList?.count {
                self.delegate?.accountListViewDoestContainAccount(self)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.accountList?.count)!
    }
}

class MMLoginAccountCell: UITableViewCell {
    
    let lineView = UIView()
    let userNameLabel = UILabel()
    let userIconImageView = UIImageView()
    let removeButton = UIButton.init(type: UIButtonType.custom)
    var bRemoveHandle : MMVoidCallBack?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        lineView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        self.contentView.addSubview(self.lineView)
        
        userIconImageView.image = UIImage.init(named: "MM_default_user_icon")
        userIconImageView.layer.cornerRadius = 15
        userIconImageView.layer.masksToBounds = true
        self.contentView.addSubview(userIconImageView)
        
        userNameLabel.font = UIFont.systemFont(ofSize: 14)
        userNameLabel.text = "43fr"
        self.contentView.addSubview(userNameLabel)
        
        removeButton.setImage(UIImage.init(named: "MM_remove_button"), for: .normal)
        removeButton.addTarget(self, action: #selector(removeButtonHandle), for: .touchUpInside)
        self.contentView.addSubview(removeButton)
        
        self.selectionStyle = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.height.equalTo(1/UIScreen.main.scale)
            make.bottom.equalTo(self.contentView)
        }
        
        userIconImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 30, height: 30))
            make.centerY.equalTo(self.userNameLabel)
            make.left.equalTo(self.lineView)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.lineView.snp.top)
            make.left.equalTo(self.userIconImageView.snp.right).offset(10)
            make.right.equalTo(self.removeButton.snp.left).offset(-10)
        }
        
        removeButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 30, height: 30))
            make.centerY.equalTo(self.userNameLabel.snp.centerY)
            make.right.equalTo(self.contentView)
        }
    }
    
    class func cellIdentifier()->String{
        
        return "MMLoginAccountCell"
    }
    
    public func configWith(_ model:MMAccountModel){
    
        self.userNameLabel.text = model.name
        self.userIconImageView.image = UIImage.init(named: model.icon!)
    }
    
    // MARK: Action M
    func removeButtonHandle(_ button:UIButton){
        if nil != bRemoveHandle {
            self.bRemoveHandle!()
        }
    }
}
