//
//  ResourceRow.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/13.
//

import SwiftUI
import LeanCloud

typealias SuccessCallback = ()->()

struct ResourceRow: View {
    var resource: Resource
    @State var isActionSheet: Bool = false
    var callback: SuccessCallback?
    var body: some View {
        HStack {
            Text("\(resource.level.intValue ?? 0)"+resource.resourceType.stringValue!)
                .frame(width: 50, height: 30)
            Spacer().frame(width: 50, height: 30)
            Text(resource.location.stringValue!)
            Spacer()
            if resource.isIllegal.boolValue! {
                Image(systemName: "star")
            }
            if resource.owner != nil {
                Text(resource.owner!.name.stringValue!)
            }
            
        }
        .onTapGesture {
            if resource.owner != nil {
                self.isActionSheet = true
            }
        }
        .actionSheet(isPresented: $isActionSheet, content: { //此处为ActionSheet的文本与事件
            ActionSheet(title: Text("对地块操作"), buttons: [
                .default(Text(getMarkTitle()), action: {
                    self.markIlleagle()
                }),
                .destructive(Text("没收"), action: {
                    self.confiscateResource()
                }),
                .cancel(Text("取消"))
            ])
        })
    }
    
    func markIlleagle() {
        if self.resource.isIllegal.boolValue! {
            self.resource.isIllegal = LCBool(false)
        } else {
            self.resource.isIllegal = LCBool(true)
        }
        _ = self.resource.save { result in
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
    
    func getMarkTitle() -> String {
        if self.resource.isIllegal.boolValue! {
            return "取消标记"
        } else {
            return "标记违规"
        }
    }
    
    func confiscateResource() {
        let player = resource.owner
        do {
            try player!.increase("copperProduction", by: -resource.produceForLevel(level: resource.level.intValue!))
            _ = player!.save { result in
                switch result {
                case .success:
                    resource.owner = nil
                    resource.isIllegal = LCBool(false)
                    _ = resource.save { result in
                        switch result {
                        case .success:
                            if callback != nil {
                                callback!()
                                //                        _ = LCObject.fetch(DataStore.shared.players)
//                                _ = LCObject.fetch(DataStore.shared.players, keys: ["copperProduction", "league", "team"])
                            }
                            break
                        case .failure(error: let error):
                            print(error)
                        }
                    }
                    break
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
}

struct ResourceRow_Previews: PreviewProvider {
    static var previews: some View {
        let resource = Resource(objectId: "5fab52e47f22434137f45ee4")
        ResourceRow(resource: resource, isActionSheet: false)
    }
}
