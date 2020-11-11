//
//  League.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/29.
//
//

import Foundation
import LeanCloud

class League: LCObject {
    
    @objc dynamic var name = LCString("")
    @objc dynamic var serverId = LCNumber(0)
    @objc dynamic var owner: Zone?

    override static func objectClassName() -> String {
        return "League"
    }
    
    func updateWith(dic: Dictionary<String, Any>) {
        self.name = LCString(dic["name"] as! String)
        self.serverId = LCNumber(integerLiteral: dic["serverId"] as! Int)
    }
}
