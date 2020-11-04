//
//  Season.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/29.
//
//

import Foundation
import LeanCloud

class Season: LCObject {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var seasonId = 0
    dynamic var name = ""
    
//    let counties = LinkingObjects(fromType: County.self, property: "season")
}
