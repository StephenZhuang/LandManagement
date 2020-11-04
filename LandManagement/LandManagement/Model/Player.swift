//
//  Player.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/29.
//
//

import Foundation
import LeanCloud

class Player: LCObject {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    /// 游戏名
    dynamic var name = ""
    
    /// 游戏id
    dynamic var playerId = 0
    
    /// 势力值
    dynamic var power = 0
    
    /// 战功
    dynamic var achievement = 0
    
    /// 分组
    dynamic var group: Group?
    
    /// 同盟
    dynamic var league: League?
    
    /// 所有土地
//    let resources = LinkingObjects(fromType: Resource.self, property: "owner")
    
    
}
