//
//  StringExtension.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/5.
//

import Foundation

extension String {
    func isPhone () -> Bool {
        let pattern2 = "^1[0-9]{10}$"

        if NSPredicate(format: "SELF MATCHES %@", pattern2).evaluate(with: self) {
            return true

        }

        return false

    }
    
}

extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

