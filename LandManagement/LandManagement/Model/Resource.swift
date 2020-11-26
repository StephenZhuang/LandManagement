//
//  Resource.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/29.
//
//

import Foundation
import LeanCloud

class Resource: LCObject {
    
    override static func objectClassName() -> String {
        return "Resource"
    }
    enum ResourceType: String {
        case copper = "铜"
        case wood = "木"
        case iron = "铁"
        case stone = "石"
        case food = "粮"
        case unknown = ""
    }
    
    @objc dynamic var resourceType: LCString = LCString(ResourceType.unknown.rawValue)
    
    /// 坐标
    @objc dynamic var location = LCString("")
    
    /// 等级
    @objc dynamic var level = LCNumber(0)
    
    /// 所有者
    @objc dynamic var owner: Player?
    
    /// 所属郡
    @objc dynamic var county: County?
    
    /// 是否违规
    @objc dynamic var isIllegal: LCBool = LCBool(false)
    
    func updateWith(dic: Dictionary<String, Any>) {
        self.resourceType = LCString(dic["sourceType"] as! String)
        self.location = LCString(dic["location"] as! String)
        self.level = LCNumber(integerLiteral: dic["level"] as! Int)
    }
    
    func produceForLevel(level: Int) -> Int {
        switch level {
        case 6:
            return 100
        case 7:
            return 200
        case 8:
            return 300
        case 9:
            return 400
        case 10:
            return 500
        default:
            return 0
        }
    }
}
