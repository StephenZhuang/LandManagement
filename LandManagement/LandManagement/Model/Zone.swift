//
//  Zone.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/29.
//
//

import Foundation
import LeanCloud

class Zone: LCObject {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    @objc dynamic var owner: LCUser?
    @objc dynamic var name: LCString = LCString("")
    override static func objectClassName() -> String {
        return "Zone"
    }
}
