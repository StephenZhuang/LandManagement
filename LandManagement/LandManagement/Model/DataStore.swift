//
//  DataStore.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/20.
//

import Foundation
import LeanCloud

class DataStore: ObservableObject {
    static let shared = DataStore()
    private var selectedZone = Zone(objectId: AppUserDefaults.selectedZone)
    @Published var leagues: [League] = []
    @Published var teams: [Team] = []
    @Published var players: [Player] = []
    @Published var counties: [County] = []
    @Published var allResources: [Resource] = []
    @Published var resourceData: [CountyAndResources] = []
    
    init() {
        self.fetchLeagues()
        self.fetchTeams()
        self.fetchPlayers()
    }
    
    func fetchLeagues() {
        do {
            let query = LCQuery(className: "League")
            try query.where("owner", .equalTo(selectedZone))
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):
                    for object in objects {
                        let league = object as! League
                        self.leagues.append(league)
                    }

                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func fetchTeams() {
        do {
            let innerQuery = LCQuery(className: "League")
            try innerQuery.where("owner", .equalTo(self.selectedZone))
            let query = LCQuery(className: "Team")
            query.whereKey("league", .matchedQuery(innerQuery))
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):
                    for object in objects {
                        let team = object as! Team
                        self.teams.append(team)
                    }
                    
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func fetchPlayers() {
        do {
            let innerQuery = LCQuery(className: "League")
            try innerQuery.where("owner", .equalTo(self.selectedZone))
            let query = LCQuery(className: "Player")
            query.whereKey("league", .matchedQuery(innerQuery))
            query.whereKey("team", .included)
            query.whereKey("league", .included)
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):
                    for object in objects {
                        let player = object as! Player
                        self.players.append(player)
                    }
                    
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func fetchCounties(callback: @escaping SuccessCallback) {
        self.counties = []
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
                    self.fetchResources(callback: callback)
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func fetchResources(callback: @escaping SuccessCallback) {
        self.allResources = []
        do {
            let innerQuery = LCQuery(className: "County")
            try innerQuery.where("owner", .equalTo(selectedZone))
            let query = LCQuery(className: "Resource")
            query.whereKey("county", .matchedQuery(innerQuery))
            query.whereKey("owner", .included)
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):

//                    for county in self.counties {
//                        var resources: [Resource] = []
                        for object in objects {
                            let resource = object as! Resource
//                            if resource.county?.objectId == county.objectId {
//                                resources.append(resource)
                                self.allResources.append(resource)
//                            }
                        }
//                        let countyAndResources = CountyAndResources(county: county, resources: resources)
//                        data.append(countyAndResources)
//                    }
                callback()
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func orderResourceData() {
        resourceData = []
//        DispatchQueue.global().async {
            for county in self.counties {
                var resources: [Resource] = []
                for resource in self.allResources {
                    if resource.county?.objectId == county.objectId {
                        resources.append(resource)
                    }
                }
                let countyAndResources = CountyAndResources(county: county, resources: resources)
                self.resourceData.append(countyAndResources)
            }
//        }
    }
}
