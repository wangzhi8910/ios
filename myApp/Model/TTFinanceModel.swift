//
//  TTFinanceModel.swift
//  myApp
//
//  Created by wangzhi on 2017/6/25.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import HandyJSON
class TTFinanceModel: HandyJSON {
    var coin_count:Int64?
    var feather_count:Int64?
    var feather_last:Int64?
    var feather_send_total:Int64?
    var coin_spend_total:Int64?
    var bean_count:Int64?
    var bean_count_total:Int64?
    required init() {}
}
