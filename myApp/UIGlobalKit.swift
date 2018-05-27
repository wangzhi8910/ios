//
//  UIGlobalKit.swift
//  myApp
//
//  Created by wangzhi on 2017/6/28.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import UIKit
let margin:CGFloat = 8
let cellMargin:CGFloat = 8
let cellCount:CGFloat = 2;
let topMargin:CGFloat = 16;

class UIGlobalKit: NSObject {
    static func createRoomLayout(_ filterType:MMRoomFilterType)->UICollectionViewFlowLayout{
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = cellMargin
        
        let tmpwidth = (kScreenWidth-(margin*2+cellMargin*(cellCount-1)))/cellCount
        var tmpheight = tmpwidth+60
        
        if (filterType == .kThirtyminute){
            tmpheight = -20.0
        }
        flowLayout.itemSize = CGSize.init(width: tmpwidth, height: tmpheight)
        flowLayout.sectionInset = UIEdgeInsetsMake(topMargin, margin, 0, margin)
        return flowLayout
    }
    

}
