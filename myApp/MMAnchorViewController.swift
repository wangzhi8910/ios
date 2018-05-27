//
//  MMAnchorViewController.swift
//  myApp
//
//  Created by wangzhi on 2017/7/31.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class MMAnchorViewController:UIViewController{
    let contentScroll:UIScrollView = {
        let cs = UIScrollView.init()
        cs.isPagingEnabled = true
        cs.isUserInteractionEnabled = true
        cs.bounces = false
        cs.showsHorizontalScrollIndicator = true
        return cs
    }()
    
    let tableView:UITableView = {
        let tv = UITableView.init()
        tv.rowHeight = 60
        return tv
    }()
    
    let segmentView:MMAnchorSegmentView = {
        let sg = MMAnchorSegmentView.init()
        return sg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(segmentView)
        self.view.addSubview(tableView)
        tableView.dataSource = self
        segmentView.config(valueChangeHandle: { [unowned self]  index in
            print (index)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(64)
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom).offset(0)
            make.bottom.equalToSuperview()
        }
    }
}

extension MMAnchorViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }

}

