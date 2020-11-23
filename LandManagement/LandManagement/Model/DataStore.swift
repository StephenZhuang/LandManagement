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
}
