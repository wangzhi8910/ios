//
//  GlobalDefine.swift
//  myApp
//
//  Created by wangzhi on 2017/6/28.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import UIKit
/// 屏幕宽度
let kScreenHeight = UIScreen.main.bounds.height
///  屏幕高度
let kScreenWidth = UIScreen.main.bounds.width

enum MMRoomFilterType:Int{
    case  kRoomNone,kFifteenDays,kHour,kThirtyminute
}

enum MMRoomType:Int{
    case  kNormalRoom = 1,///< 传统直播间
    kMobileRoom = 2///< 手机直播间
}

enum MMTabBarContollerTags:Int{
    ///首页
    case kTabHomeTag = 0,
    ///关注
    kTabFriendTag,
    ///消息
    kTabMessageTag,
    ///账号
    kTabMineTag
    
}

