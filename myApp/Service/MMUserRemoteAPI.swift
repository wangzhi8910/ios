//
//  MMUserRemoteAPI.swift
//  myApp
//
//  Created by wangzhi on 2017/6/22.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import Moya

let userProvider = MoyaProvider<MMUserRemoteAPI>()

public enum MMUserRemoteAPI {
    case login(userName:String,password:String)
    case updateUserInfo(token:String)
    case anchorHotRecommend
}

extension MMUserRemoteAPI: TargetType {
    public var baseURL: URL { return URL(string: "https://api.memeyule.com/")! } //    https://user.memeyule.com
    public var path: String {
        switch self {
        case .login(let userName,let password):
            return "/login?login_name=\(userName)&pwd=\(password)"
        case .updateUserInfo(let token):
            return "/user/info/\(token)?qd=iOS_meme"
        case .anchorHotRecommend:
            return "/app2/home"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login(_,_):
            return .post
        case .updateUserInfo(_):
            return .get
        case .anchorHotRecommend:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .login(_,_),.updateUserInfo(_),.anchorHotRecommend:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        switch self {
        case .login(_,_),.updateUserInfo(_),.anchorHotRecommend:
            return .request
        }
    }
    
     //这个就是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    public var sampleData: Data {
        switch self {
        case .login(let userName ,let password):
            return "".data(using: String.Encoding.utf8)!
        default:
            return "".data(using: String.Encoding.utf8)!
        }
    }
}

