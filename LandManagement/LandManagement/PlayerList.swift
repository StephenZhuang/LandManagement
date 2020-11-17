//
//  PlayerList.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/16.
//

import SwiftUI
import LeanCloud

struct PlayerList: View {
    var league: League
    @State private var teams: [Team] = []
    @State private var players: [Player] = []
    @State private var data: [TeamAndPlayers] = []
    var body: some View {
        VStack {
            List {
                ForEach(self.data, id: \.self) { teamAndPlayers in
                    Section(header: HStack{
                        Text(teamAndPlayers.team.name.stringValue!)
                        Spacer()
                        Text("\(teamAndPlayers.players.count)人")
                    }) {
                        ForEach(teamAndPlayers.players, id: \.self) { player in
                            Text(player.name.stringValue!)
                        }
                    }
                }
            }.listStyle(SidebarListStyle())
        }.navigationBarTitle(league.name.stringValue!)
        .onAppear() {
            if players.count <= 0 {
                self.fetchTeams()
            }
        }
    }
    
    func fetchTeams() {
        do {
            let query = LCQuery(className: "Team")
            try query.where("league", .equalTo(self.league))
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):
                    for object in objects {
                        let team = object as! Team
                        self.teams.append(team)
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
    
    func fetchPlayers() {
        do {
            let innerQuery = LCQuery(className: "Team")
            try innerQuery.where("league", .equalTo(self.league))
            let query = LCQuery(className: "Player")
            query.whereKey("team", .matchedQuery(innerQuery))
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):
                    for object in objects {
                        let player = object as! Player
                        self.players.append(player)
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
    
    func orderData() {
        for team in self.teams {
            var teamPlayers: [Player] = []
            for player in self.players {
                
                if player.team == team {
                    teamPlayers.append(player)
                }
            }
            let teamAndPlayers = TeamAndPlayers(team: team, players: teamPlayers)
            data.append(teamAndPlayers)
        }
    }
}

struct PlayerList_Previews: PreviewProvider {
    static var previews: some View {
        let league = League(objectId: "5fab894b7f22434137f48c3f")
        PlayerList(league: league)
    }
}
