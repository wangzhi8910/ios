//
//  TTUserModel.swift
//  myApp
//
//  Created by wangzhi on 2017/6/23.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import HandyJSON

struct Coordinate {
    var x:Double?
    var y:Double?
}

struct DetailInfo {
    var mobile_bind:Bool?
    var mobile:Int64?
}

struct Position {
    var province:String?
    var city:String?
    var region:String?
    var coordinate_x:Double?
    var coordinate_y:Double?
}

class Finance: HandyJSON{
    var bean_count_total:Int64?
    required init() {}
}


class TTUserModel: HandyJSON {
    var _id:Int?
    var mm_no:Int?
    var user_name:String?
    var pic:String?
    var nick_name:String?
    var priv:Int?
    var status:Bool?
    var timestamp:Int64?
    var finance:TTFinanceModel?
    var stature:Int?
    var constellation:Int?
    var sex:Int?
    var location:String?
    var refuse_friend_apply:Bool?
    var address:String?
    var coordinate:Coordinate?
    var detail_info:DetailInfo?
    var rank:Int?
    var bean_rank:Int?
    required init() {}
}
