//
//  PlayerDetailView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/20.
//

import SwiftUI
import LeanCloud

class PlayerEdit {
    var name: String = ""
    var power: String = "0"
    var achievement: String = "0"
    var playerId: String = "0"
    init() {
        
    }
    
    func update(player: Player) {
        self.name = player.name.stringValue!
        self.power = "\(player.power.intValue!)"
        self.achievement = "\(player.achievement.intValue!)"
        self.playerId = "\(player.playerId.intValue!)"
    }
}

struct PlayerDetailView: View {
    var player: Player
    @State private var playerEdit: PlayerEdit = PlayerEdit()
    @State private var editing: Bool = false
    
    @State private var selectedLeague: LeagueAndTeams = LeagueAndTeams(league: League(), teamAndPlayers: [])
    @State private var selectedTeam: TeamAndPlayers = TeamAndPlayers(team: Team(), players: [])
    @State private var data: [LeagueAndTeams] = []
    @EnvironmentObject var dataStore: DataStore
    @State private var resources: [Resource] = []
    var body: some View {
        Form {
            Section {
                
                HStack {
                    Text("游戏名")
                        .frame(width: 80, alignment: .leading)
                    if editing {
                        TextField("游戏名", text: $playerEdit.name)
                    } else {
                        Text(player.name.stringValue!)
                    }
                }
                HStack {
                    Text("游戏编号")
                        .frame(width: 80, alignment: .leading)
                    if editing {
                        TextField("游戏编号", text: $playerEdit.playerId)
                            .keyboardType(.numberPad)
                    } else {
                        Text("\(player.playerId.intValue!)")
                    }
                }
                HStack {
                    Text("势力")
                        .frame(width: 80, alignment: .leading)
                    if editing {
                        TextField("势力", text: $playerEdit.power)
                            .keyboardType(.numberPad)
                    } else {
                        Text("\(player.power.intValue!)")
                    }
                }
                HStack {
                    Text("战功")
                        .frame(width: 80, alignment: .leading)
                    if editing {
                        TextField("战功", text: $playerEdit.achievement)
                            .keyboardType(.numberPad)
                    } else {
                        Text("\(player.achievement.intValue!)")
                    }
                }
            }
            
            Section {
                if editing {
//                    HStack {
                        Picker(selection: $selectedLeague, label: Text("同盟")) {
                            ForEach(data, id:\.self) { leagueAndTeams in
                                Text(leagueAndTeams.league.name.stringValue!).tag(leagueAndTeams)
                            }
                        }.pickerStyle(InlinePickerStyle())
//                        .frame(width:160)
                        .onReceive([self.selectedLeague].publisher.first()) { (value) in
//                            let leagueAndTeams = value
                            if selectedTeam.team.league != selectedLeague.league {
                                if selectedLeague.teamAndPlayers.count > 0 {
                                    selectedTeam = selectedLeague.teamAndPlayers[0]
                                }
                            }
//                            print(leagueAndTeams.league.name.stringValue!)
//                            print(selectedTeam.team.name.stringValue!)
                        }
                        
                        Picker(selection: $selectedTeam, label: Text("分组")) {
    //                        let teams = selectedLeague!.teamAndPlayers
                            ForEach(selectedLeague.teamAndPlayers, id: \.self) { teamAndPlayers in
                                Text(teamAndPlayers.team.name.stringValue!).tag(teamAndPlayers)
                            }
                        }.pickerStyle(InlinePickerStyle())
//                        .frame(width:160)
//                    }
                
                } else {
                    HStack {
                        Text("同盟")
                            .frame(width: 80, alignment: .leading)
                        Text(player.league?.name.stringValue ?? "")
                    }
                    HStack {
                        Text("分组")
                            .frame(width: 80, alignment: .leading)
                        Text(player.team?.name.stringValue ?? "")
                    }
                }
            }
            
            Section(header: Text("资源")) {
                ForEach(resources, id: \.self) { resource in
                    ResourceRow(resource: resource) {
                        self.orderData()
                        self.resources.remove(resource)
                    }
                }
            }
            
        }.navigationBarItems(trailing: Button(getButtonTitle(), action: {
            if editing {
                print(selectedLeague.league.name.stringValue!)
                print(selectedTeam.team.name.stringValue!)
            }
            editing.toggle()
        }))
        .navigationBarTitle("个人信息")
        .onAppear() {
            self.playerEdit.update(player: player)
            orderData()
            self.fetchResource()
        }
    }
    
    func orderData() {
        data = []
        for league in dataStore.leagues {
            var teams: [TeamAndPlayers] = []
            for team in dataStore.teams {
                if team.league == league {
                    let players: [Player] = []
                    let teamAndPlayers = TeamAndPlayers(team: team, players: players)
                    teams.append(teamAndPlayers)
                    if team == player.team {
                        selectedTeam = teamAndPlayers
                    }
                }
            }
            let leagueAndTeams = LeagueAndTeams(league: league, teamAndPlayers: teams)
            if league == player.league {
                selectedLeague = leagueAndTeams
            }
            data.append(leagueAndTeams)
        }
    }
    
    func getButtonTitle() -> String {
        if editing {
            return "保存"
        } else {
            return "编辑"
        }
    }
    
    func fetchResource() {
        do {
            let query = LCQuery(className: "Resource")
            try query.where("owner", .equalTo(player))
            query.whereKey("owner", .included)
            let _ = query.find { (result) in
                
                switch result {
                case .success(objects: let objects):
    
                    self.resources = []
                    for object in objects {
                        let resource = object as! Resource
                        self.resources.append(resource)
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

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player(objectId: "5fab8b1c7f22434137f48d1b")
        PlayerDetailView(player: player)
    }
}
