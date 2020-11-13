//
//  ZoneListView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/6.
//

import SwiftUI
import LeanCloud
import SwiftUIRefresh

struct ZoneListView: View {
    @EnvironmentObject var showingView: ShowingView
//    @Binding var isPushed: Bool
    @State var myZone: Zone?
//    @State private var managedZones: [Zone]
    
    @State private var showAddButton: Bool = false
    @State private var refreshing: Bool = false
    var body: some View {
        VStack {
            List {
                
                Section(header: Text("我创建的")) {
                    if myZone != nil {
                        
                        Button {
                            AppUserDefaults.selectedZone = myZone?.objectId?.stringValue ?? ""
                            self.showingView.viewId = .Tab
                        } label: {
                            Text(myZone!.name.stringValue ?? "")
                        }
                    }
                    if showAddButton {
                        Button {
                            self.addZone()
                        } label: {
                            Text("创建一个新的土管所")
                        }
                    }
                    
                }
                Section(header: Text("我管理的")) {
                    
                }
            }
        }.pullToRefresh(isShowing: $refreshing) {
            self.fetchMyZone()
        }
        .navigationBarTitle("土管所")
        .navigationBarHidden(false)
        .onAppear { self.fetchMyZone() }
        
    }
    
    func addZone() {
        //TODO
        let zone = Zone(objectId: "5fa511897f22434137eba27b")
        zone.name = LCString("152威震华夏")
        zone.owner = LCApplication.default.currentUser

        // 将对象保存到云端
        _ = zone.save { result in
            switch result {
            case .success:
                // 成功保存之后，执行其他逻辑
                break
            case .failure(error: let error):
                // 异常处理
                print(error)
            }
        }
    }
    
    func fetchMyZone() {
        do {
            let query = LCQuery(className: "Zone")
            try query.where("owner", .equalTo(LCApplication.default.currentUser!))
            let _ = query.getFirst { (result) in
                refreshing = false
                switch result {
                case .success(object: let zone):
                    
                    myZone = zone as? Zone
                case .failure(error: let error):
                    print(error)
                    showAddButton = true
                }
            }
        } catch {
            print(error)
        }
    }
    
}

struct ZoneListView_Previews: PreviewProvider {
    static var previews: some View {
        let zone = Zone(objectId: "5fa511897f22434137eba27b")
        ZoneListView(myZone: zone)
    }
}
