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
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
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
    @objc dynamic var location = ""
    
    /// 等级
    @objc dynamic var level = 0
    
    /// 所有者
    @objc dynamic var owner: Player?
    
    /// 所属郡
    @objc dynamic var county: County?
    
}
