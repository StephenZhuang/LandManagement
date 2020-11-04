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
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var name = ""
    dynamic var serverId = 0
//    let groups = List<Group>()
//    let players = LinkingObjects(fromType: Player.self, property: "league")
}
