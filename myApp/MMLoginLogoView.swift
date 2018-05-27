//
//  MMLoginLogoView.swift
//  myApp
//
//  Created by user1 on 2017/6/22.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import UIKit

class MMLoginLogoView: UIView {

    let logoImageView = UIImageView.init(image: UIImage.init(named: "MM_login_mask_img"))
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(logoImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
