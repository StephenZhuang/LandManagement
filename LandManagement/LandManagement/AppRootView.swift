//
//  AppRootView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/12.
//

import SwiftUI

//Your app views
enum AppViews {
    case Login
    case ZoneList
    case Tab
}

//Class that conforms to the ObservableObject protocol and publishes the viewId property.
//Basically your navigation will react to viewId changes

class ShowingView: ObservableObject {
    
    init(showingView: AppViews) {
        self.viewId = showingView
    }
    
    @Published var viewId : AppViews
}

//The current root view of your app is observing changes of the ShowingView class and switch between your app views
struct AppRootView: View {
    
    @ObservedObject var showingView: ShowingView
    
    var body: some View {
            if showingView.viewId == .Login {
                NavigationView {
                    LoginView()
                        .environmentObject(showingView)
                }
            } else if showingView.viewId == .ZoneList {
                NavigationView {
                    ZoneListView()
                        .environmentObject(showingView)
                }
            } else {
                LandManagementTabView()
                    .environmentObject(showingView)
            }
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView(showingView: ShowingView(showingView: .Login))
    }
}
