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
    @State private var dic: Dictionary<String, [Resource]> = Dictionary()

    var body: some View {
        let keys = dic.map{$0.key}

        VStack {
            List {
                ForEach(keys, id: \.self) { key in
                    let resources: [Resource] = dic[key]!
                    Section(header: Text(key)) {
                        ForEach(resources, id: \.self) { resource in
                            ResourceRow(resource: resource)
                        }
                    }
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
                self.fetchCounties()
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
//                    self.counties = objects as! [County]
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
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):

                    for county in self.counties {
                        var resources: [Resource] = []
                        for object in objects {
                            let resource = object as! Resource
                            if resource.county?.objectId == county.objectId {
                                resources.append(resource)
                            }
                        }
                        dic[county.name.stringValue!] = resources
                    }
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
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
