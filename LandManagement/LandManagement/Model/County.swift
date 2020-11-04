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

    @objc dynamic var name: LCString = ""
    @objc dynamic var state = ""
//    @objc dynamic var countyId = ObjectId.generate()
    @objc dynamic var season: Season?
    
//    let resources = Resource.relationForKey("county")
    override static func objectClassName() -> String {
            return "County"
        }
}
