//
//  LandManagementTabView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/9.
//

import SwiftUI

struct LandManagementTabView: View {
    @State private var selection = Tabs.resource
    @EnvironmentObject var showView: ShowingView
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ResourceList().tabItem {
                    Image(systemName:"command")
                    Text("资源")
                }.tag(Tabs.resource)
                
                AppraiseList()
                    .environmentObject(DataStore.shared)
                    .tabItem {
                        Image(systemName:"rectangle.and.paperclip")
                        Text("考核")
                    }
                    .tag(Tabs.appraise)
                
                SettingsView().environmentObject(showView).tabItem {
                    Image(systemName:"slider.horizontal.3")
                    Text("设置")
                }.tag(Tabs.settings)
            }.navigationBarTitle(returnNaviBarTitle(tabSelection: self.selection))
        }
    }
    
    enum Tabs{
            case resource, appraise, settings
        }
        
        func returnNaviBarTitle(tabSelection: Tabs) -> String{
            switch tabSelection{
            case .resource:
                return "资源"
            case .appraise:
                return "考核"
            case .settings:
                return "设置"
            }
        }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        LandManagementTabView()
    }
}

//class TabBarState: ObservableObject {
//   @Published var hidden : Bool = false
//}
