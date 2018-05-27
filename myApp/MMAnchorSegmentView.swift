//
//  MMAnchorSegmentView.swift
//  myApp
//
//  Created by wangzhi on 2017/7/31.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import UIKit

class MMAnchorSegmentView: UIView {
    var valueChangeBlock:MMIntCallBack?
    let segmentControl :UISegmentedControl = {
        let sg = UISegmentedControl.init(items:["关注","守护","管理"])
        sg.addTarget(self, action:#selector(segmentValueChanged(_:)), for: UIControlEvents.valueChanged)
        return sg
    }()
    
    init(){
        super.init(frame: .zero)
        self.addSubview(segmentControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        segmentControl.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(8, 18, 8, 18))
        }
    }
    
    func config(valueChangeHandle:MMIntCallBack?){
        
        valueChangeBlock = valueChangeHandle
    }
    
    func segmentValueChanged(_ seg:UISegmentedControl){
        valueChangeBlock?(seg.selectedSegmentIndex)
    }
}
