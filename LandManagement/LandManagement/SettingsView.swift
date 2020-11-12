//
//  SettingsView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/9.
//

import SwiftUI
import LeanCloud

struct SettingsView: View {
    @EnvironmentObject var showingView: ShowingView
    var body: some View {
        VStack {
            List {
                Button {
                    self.logout()
                } label: {
                    Text("退出登录")
                }
                
            }
        }
        .navigationBarTitle("设置")
        
    }
    
    func logout() {
        LCUser.logOut()
        AppUserDefaults.selectedZone = ""
        self.showingView.viewId = .Login
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(ShowingView(showingView: .Tab))
    }
}
