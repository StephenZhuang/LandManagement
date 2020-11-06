//
//  ZoneListView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/6.
//

import SwiftUI
import LeanCloud

struct ZoneListView: View {
    @Binding var isPushed: Bool
//    @State private var myZone: Zone
//    @State private var managedZones: [Zone]
    var body: some View {
        List {
            Section(header: Text("我创建的")) {
                Button {
                    self.addZone()
                } label: {
                    Text("创建一个新的土管所")
                }

            }
            Section(header: Text("我管理的")) {
                
            }
        }
        .navigationBarTitle("土管所")
    }
    
    func addZone() {
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
}

struct ZoneListView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneListView(isPushed: .constant(true))
    }
}
