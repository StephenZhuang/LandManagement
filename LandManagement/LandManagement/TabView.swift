//
//  LandManagementTabView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/9.
//

import SwiftUI

struct LandManagementTabView: View {
    var body: some View {
        TabView {
            ResourceList().tabItem {
                
            }.tag(0)
            AppraiseList()
            SettingsView()
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        LandManagementTabView()
    }
}
