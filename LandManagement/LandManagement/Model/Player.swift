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
    
    /// 游戏名
    @objc dynamic var name = LCString("")
    
    /// 游戏id
    @objc dynamic var playerId = LCNumber(0)
    
    /// 势力值
    @objc dynamic var power = LCNumber(0)
    
    /// 战功
    @objc dynamic var achievement = LCNumber(0)
    
    /// 分组
    @objc dynamic var team: Team?
    
    /// 同盟
    @objc dynamic var league: League?
    
    override static func objectClassName() -> String {
        return "Player"
    }
    
    func updateWith(dic: Dictionary<String, Any>) {
        self.name = LCString(dic["name"] as! String)
        self.playerId = LCNumber(integerLiteral: dic["playerId"] as! Int)
        self.power = LCNumber(integerLiteral: dic["power"] as! Int)
        self.achievement = LCNumber(integerLiteral: dic["achievement"] as! Int)
    }
}
