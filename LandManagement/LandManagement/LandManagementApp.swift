//
//  LandManagementApp.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/10/30.
//

import SwiftUI
import LeanCloud

@main
struct LandManagementApp: SwiftUI.App {
    
    init() {
        setupLeanCloud()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if LCApplication.default.currentUser != nil {
                    if AppUserDefaults.selectedZone.count > 0 {
                        LandManagementTabView()
                    } else {
                        ZoneListView(isPushed: .constant(true))
                    }
                } else {
                    LoginView()
                }
            }
        }
    }
}

private extension LandManagementApp {
    func setupLeanCloud() {
        do {
            try LCApplication.default.set(
                id: "YShveg1hbqs8GcUDrRJRESLG-9Nh9j0Va",
                key: "BznaJcjcD5MzEyFTe9VYrLWJ",
                serverURL: "https://yshveg1h.lc-cn-e1-shared.com")
        } catch {
            print(error)
        }
        Zone.register()
        County.register()
        Resource.register()
        League.register()
        Team.register()
        Player.register()
    }
}
