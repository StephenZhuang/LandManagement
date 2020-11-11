//
//  Team.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/29.
//
//

import Foundation
import LeanCloud

class Team: LCObject {
    
    @objc dynamic var name = LCString("")
    @objc dynamic var league: League?
    @objc dynamic var headman: Player?
    
    override static func objectClassName() -> String {
        return "Team"
    }
    
    func updateWith(dic: Dictionary<String, Any>) {
        self.name = LCString(dic["name"] as! String)
    }
}
