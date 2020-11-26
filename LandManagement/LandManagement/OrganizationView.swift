//
//  OrganizationView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/13.
//

import SwiftUI
import LeanCloud

enum OrganizationViewType {
    case showDetail
    case select
}

typealias SelectPlayerCallback = (Player) -> ()

struct OrganizationView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var data: [LeagueAndTeams] = [LeagueAndTeams(league: League(), teamAndPlayers: [])]
    @State private var selection = LeagueAndTeams(league: League(), teamAndPlayers: [])
    var viewType: OrganizationViewType
    var callback: SelectPlayerCallback?
    @State var isDetailActive = false
    @State var selectedPlayer = Player()
    @Environment(\.presentationMode) var presentation
    
    private let columns = [GridItem(.adaptive(minimum: 85))]
    var body: some View {
        NavigationLink(destination: PlayerDetailView(player: selectedPlayer), isActive: $isDetailActive) {
            EmptyView()
        }
        TabView(selection: self.$selection) {
            ForEach(data, id: \.self) { leagueAndTeams in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(leagueAndTeams.teamAndPlayers, id: \.self) { teamAndPlayers in
                            Section(header: HStack{
                                Text(teamAndPlayers.team.name.stringValue!)
                                    .padding()
                                Spacer()
                                Text("\(teamAndPlayers.players.count)人")
                                    .padding()
                            }) {
                                ForEach(teamAndPlayers.players, id: \.self) { player in
                                        cell(player: player)
                                            .onTapGesture {
                                                if viewType == .showDetail {
                                                    selectedPlayer = player
                                                    isDetailActive = true
                                                } else {
                                                    if callback != nil {
                                                        callback!(player)
                                                        self.presentation.wrappedValue.dismiss()
                                                    }
                                                }
                                            }
                                }
                            }
                        }
                    }
                }.tag(leagueAndTeams)
            }
        }.tabViewStyle(PageTabViewStyle())
        .navigationBarTitle(self.selection.league.name.stringValue!, displayMode: .inline)
        .onAppear() {
            self.orderData()
        }
    }
    
    func cell(player: Player) -> some View {
        return RoundedRectangle(cornerRadius: 10)
                .fill(Color.green)
                .frame(width: 80, height: 50)
                .overlay(Text(player.name.stringValue!).foregroundColor(Color.white))
    }
    
    func orderData() {
        data = []
        for league in dataStore.leagues {
            var teams: [TeamAndPlayers] = []
            for team in dataStore.teams {
                if team.league == league {
                    var players: [Player] = []
                    for player in dataStore.players {
                        if player.team == team {
                            players.append(player)
                        }
                    }
                    let teamAndPlayers = TeamAndPlayers(team: team, players: players)
                    teams.append(teamAndPlayers)
                }
            }
            let leagueAndTeams = LeagueAndTeams(league: league, teamAndPlayers: teams)
            data.append(leagueAndTeams)
        }
        if data.count > 0 {
            self.selection = data[0]
        }
    }
}

struct OrganizationView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationView(viewType: .showDetail)
    }
}
