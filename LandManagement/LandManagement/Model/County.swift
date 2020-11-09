//
//  County.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/29.
//
//

import Foundation
import LeanCloud

class County: LCObject {

    @objc dynamic var name: LCString = LCString("")
    @objc dynamic var state: LCString = LCString("")
    @objc dynamic var owner: Zone?
    override static func objectClassName() -> String {
        return "County"
    }
}
