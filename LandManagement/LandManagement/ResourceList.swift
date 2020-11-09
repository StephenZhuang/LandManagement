//
//  ResourceList.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/9.
//

import SwiftUI
import LeanCloud

struct ResourceList: View {
    private var selectedZone: Zone = Zone(objectId: AppUserDefaults.selectedZone)
    @State private var counties: [County] = []
    var body: some View {
        VStack {
            List {
                Button {
                    self.setupCounty()
                } label: {
                    Text("初始化county")
                }

            }
        }
        .onAppear() {
            self.fetchZone()
        }
        .navigationBarTitle("资源管理")
    }
    
    func fetchZone() {
        _ = selectedZone.fetch { result in
            switch result {
            case .success:
                // todo 已刷新
                break
            case .failure(error: let error):
                print(error)
            }
        }

    }
    
    func setupCounty() {
        let path = Bundle.main.path(forResource: "county", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
                  
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! [Dictionary<String, Any>]
            
            for dict in jsonArr {
                let county = County()
                county.name = LCString(dict["name"] as! String)
                county.state = LCString(dict["state"] as! String)
                county.owner = selectedZone
                counties.append(county)
            }
            _ = County.save(counties, completion: { (result) in
                switch result {
                case .success:
                    break
                case .failure(error: let error):
                    print(error)
                }
            })
            
        } catch let error as Error? {
            print("读取本地数据出现错误!",error!)
        }
    }
    
}

struct ResourceList_Previews: PreviewProvider {
    static var previews: some View {
        ResourceList()
    }
}
