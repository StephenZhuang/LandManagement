//
//  AppUserDefaults.swift
//  ColdCloudSwiftUI
//
//  Created by Stephen Zhuang on 2019/10/17.
//  Copyright © 2019 Changzhou Onsoft Co.,Ltd. All rights reserved.
//

import Foundation

struct AppUserDefaults {
    @UserDefault("isLogin", defaultValue: false)
    static var isLogin: Bool

    @UserDefault("sessionToken", defaultValue: "")
    static var sessionToken: String
    
    @UserDefault("phone", defaultValue: "")
    static var phone: String
}
