//
//  TTRoomModel.swift
//  myApp
//
//  Created by wangzhi on 2017/7/7.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import HandyJSON

class TTRoomModel:HandyJSON{
    var _id:Int?
    var xy_star_id:Int?
    var live:Bool?
    var bean:Int?
    var visiter_count:Int?
    var found_time:Int64?
    var room_ids:Int?
    var nick_name:String?
    var pic_url:String?
    var plugin:Int?
    var timestamp:Int64?
    var bg_url:String?
    var type:Int?
    var v_type:Int?
    var followers:Int?
    var chat_limit:Int?
    var song_price:Int?
    var mic_switch:Bool?
    var live_type:MMRoomType?
    var app_pic_url:String?
    var position:Position?
    var title:String?
    var pic:String?
    var notify_msg:String?
    var audit_app_pic_url:String?
    var mm_no:Int?
    var source:Int?
    var finance:Finance?
    var filterType:MMRoomFilterType?

    required init() {}
    
    var roomPicUrl:String?{
        if ( self.live_type == MMRoomType.kMobileRoom){
            return self.app_pic_url
        } else{
            return self.pic_url
        }
    }
    
}

