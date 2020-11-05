//
//  User.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/29.
//
//

import Foundation
import LeanCloud

class User: LCUser {
    @objc dynamic var nickname: LCString = LCString("")
}

