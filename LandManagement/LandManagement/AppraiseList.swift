//
//  AppraiseList.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/9.
//

import SwiftUI
import LeanCloud

struct AppraiseList: View {
    private var selectedZone: Zone = Zone(objectId: AppUserDefaults.selectedZone)
    @State private var allPlayers: [Player] = []
    @State private var data: [LeagueAndPlayers] = []
    @State private var leagues: [League] = []
    @State var selectedValue = LeagueAndPlayers(league: League(), players: [])
    
    var body: some View {
        VStack {
            List {
                Picker(selection: $selectedValue, label: Text("盟")) {
                    ForEach(self.data, id: \.self) { leagueAndPlayers in
                        Text(leagueAndPlayers.league.name.stringValue!).tag(leagueAndPlayers)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if data.count > 0 {
                    let leagueAndPlayers = selectedValue
                    let players = leagueAndPlayers.players
                    HStack {
                        Text("名字")
                            .frame(width: 110, height: 30, alignment: .leading)

                        Spacer()
                        Text("势力值")
                            .frame(width: 60)
                        Spacer()
                        Text("战功")
                            .frame(width: 60)
                        Spacer()
                        Text("铜产")
                            .frame(width: 50)
                    }
                    ForEach(players, id: \.self) { player in
                        HStack {
                            
                            Text(player.name.stringValue!)
                                .frame(width: 110, height: 30, alignment: .leading)

                            Spacer()
                            Text("\(player.power.intValue!)")
                                .frame(width: 60)
                            Spacer()
                            Text(getShortAchivement(achivement: player.achievement.intValue!))
                                .frame(width: 60)
                            Spacer()
                            Text("\(player.copperProduction.intValue!)")
                                .frame(width: 50)
                        }
                    }
                }
            }
        }.onAppear() {
            if allPlayers.count <= 0 {
                self.fetchLeagues()
            }
        }
    }
    
    func getShortAchivement(achivement: Int) -> String {
        var short = ""
        if achivement > 10000 {
            short = "\(achivement / 10000)万"
        } else {
            short = "\(achivement)"
        }
        return short
    }
    
    func fetchPlayers() {
        do {
            let innerQuery = LCQuery(className: "League")
            try innerQuery.where("owner", .equalTo(self.selectedZone))
            let query = LCQuery(className: "Player")
            query.whereKey("achievement", .descending)
            query.whereKey("league", .matchedQuery(innerQuery))
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):
                    for object in objects {
                        let player = object as! Player
                        self.allPlayers.append(player)
                    }
                    self.orderData()
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
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
                    self.fetchPlayers()
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func orderData() {
        for league in leagues {
            var playerArray: [Player] = []
            for player in allPlayers {
                if league == player.league {
                    playerArray.append(player)
                }
            }
            let leagueAndPlayers = LeagueAndPlayers(league: league, players: playerArray)
            data.append(leagueAndPlayers)
        }
        if data.count > 0 {
            self.selectedValue = self.data[0]
        }
    }
}

struct AppraiseList_Previews: PreviewProvider {
    static var previews: some View {
        AppraiseList()
    }
}
