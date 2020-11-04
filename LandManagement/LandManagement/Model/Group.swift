//
//  Group.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/29.
//
//

import Foundation
import LeanCloud

class Group: LCObject {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var name = ""
    
//    let players = Player.relationForKey("group")
}
