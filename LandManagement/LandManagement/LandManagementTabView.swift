//
//  LandManagementTabView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/9.
//

import SwiftUI

struct LandManagementTabView: View {
    @State private var selection = 0
    @EnvironmentObject var showView: ShowingView
    var body: some View {

        TabView(selection: $selection) {
            NavigationView {
                ResourceList()
            }
            .tabItem {
                Image(systemName:"command")
                Text("资源")
            }.tag(0)
            
            NavigationView {
                AppraiseList()
            }
            .tabItem {
                Image(systemName:"rectangle.and.paperclip")
                Text("考核")
            }.tag(1)
            
            NavigationView {
                SettingsView().environmentObject(showView)
            }
            .tabItem {
                Image(systemName:"slider.horizontal.3")
                Text("设置")
            }.tag(2)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        LandManagementTabView()
    }
}
