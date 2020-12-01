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
    @State private var allResources: [Resource] = []
    @State private var data: [CountyAndResources] = []
    @State private var isActionSheet = false
    
    var body: some View {

        VStack {
            List {
                ForEach(data, id: \.self) { countyAndResources in
                    let resources: [Resource] = countyAndResources.resources
                    Section(header: Text(countyAndResources.county.name.stringValue!)) {
                        ForEach(resources, id: \.self) { resource in
                            if resource.owner == nil {
                                NavigationLink(destination: OrganizationView(viewType: .select, callback: { (player) in
                                    resourceAssign(resource: resource, player: player)
                                }).environmentObject(DataStore.shared)) {
                                    ResourceRow(resource: resource)
                                }
                            } else {
                                ResourceRow(resource: resource) {
                                    self.orderData()
                                }
                            }
                        }
                    }
                }
            }.listStyle(SidebarListStyle())
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
                if self.allResources.count > 0 {
                    
                } else {                
                    self.fetchCounties()
                }
                break
            case .failure(error: let error):
                print(error)
            }
        }

    }
    
    func fetchCounties() {
        do {
            let query = LCQuery(className: "County")
            try query.where("owner", .equalTo(selectedZone))
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):
                    for object in objects {
                        let county = object as! County
                        self.counties.append(county)
                    }
                    self.fetchResources()
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func fetchResources() {
        do {
            let innerQuery = LCQuery(className: "County")
            try innerQuery.where("owner", .equalTo(selectedZone))
            let query = LCQuery(className: "Resource")
            query.whereKey("county", .matchedQuery(innerQuery))
            query.whereKey("owner", .included)
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):

                    for county in self.counties {
                        var resources: [Resource] = []
                        for object in objects {
                            let resource = object as! Resource
                            if resource.county?.objectId == county.objectId {
                                resources.append(resource)
                                self.allResources.append(resource)
                            }
                        }
                        let countyAndResources = CountyAndResources(county: county, resources: resources)
                        data.append(countyAndResources)
                    }
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func orderData() {
        data = []
        DispatchQueue.global().async {
            for county in self.counties {
                var resources: [Resource] = []
                for resource in self.allResources {
                    if resource.county?.objectId == county.objectId {
                        resources.append(resource)
                    }
                }
                let countyAndResources = CountyAndResources(county: county, resources: resources)
                data.append(countyAndResources)
            }
        }
    }
    
    func resourceAssign(resource: Resource, player: Player) {
        resource.owner = player
        _ = resource.save { result in
            switch result {
            case .success:
                // 成功保存之后，执行其他逻辑
                do {
                    try player.increase("copperProduction", by: resource.produceForLevel(level: resource.level.intValue!))
                    _ = player.save()
                    self.orderData()
                } catch {
                    print(error)
                }
                break
            case .failure(error: let error):
                // 异常处理
                print(error)
            }
        }
    }
    
    
    
    
}

struct sampleView: View {
    private var selectedZone: Zone = Zone(objectId: AppUserDefaults.selectedZone)
    @State private var counties: [County] = []
    @State private var resources: [Resource] = []
    @State private var teams: [Team] = []
    @State private var players: [Player] = []
    @State private var leagues: [League] = []
    var body: some View {
        List {
            Button {
                self.setupCounty()
            } label: {
                Text("初始化county")
            }

            Button {
                self.setupResource()
            } label: {
                Text("初始化resource")
            }
            
            Button {
                self.setupLeague()
            } label: {
                Text("初始化league")
            }
            
            Button {
                self.setupTeam()
            } label: {
                Text("初始化team")
            }
            
            Button {
                self.setupPlayer()
            } label: {
                Text("初始化player")
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
                county.updateWith(dic: dict)
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
    
    func setupResource() {
        let path = Bundle.main.path(forResource: "resource", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
                  
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! [Dictionary<String, Any>]
            
            for dict in jsonArr {
                let county = County(objectId: "5fa90e387f22434137f01636")
                let resource = Resource()
                resource.county = county
                resource.updateWith(dic: dict)
                resources.append(resource)
            }
            _ = Resource.save(resources, completion: { (result) in
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
    
    func setupLeague() {
        let path = Bundle.main.path(forResource: "league", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
                  
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! [Dictionary<String, Any>]
            
            for dict in jsonArr {
                let league = League()
                league.updateWith(dic: dict)
                league.owner = selectedZone
                leagues.append(league)
            }
            _ = League.save(leagues, completion: { (result) in
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
    
    func setupTeam() {
        let path = Bundle.main.path(forResource: "team", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
                  
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! [Dictionary<String, Any>]
            
            for dict in jsonArr {
                let league = League(objectId: "5fab894b7f22434137f48c3f")
                let team = Team()
                team.league = league
                team.updateWith(dic: dict)
                teams.append(team)
            }
            _ = Team.save(teams, completion: { (result) in
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
    
    func setupPlayer() {
        let path = Bundle.main.path(forResource: "player", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
                  
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! [Dictionary<String, Any>]
            
            for dict in jsonArr {
                let league = League(objectId: "5fab894b7f22434137f48c3f")
                let team = Team(objectId: "5fab8a467f22434137f48ccf")
                let player = Player()
                player.league = league
                player.team = team
                player.updateWith(dic: dict)
                players.append(player)
            }
            _ = Player.save(players, completion: { (result) in
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
