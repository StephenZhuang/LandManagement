//
//  AppraiseList.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/9.
//

import SwiftUI
import LeanCloud

struct AppraiseList: View {
    @State private var data: [LeagueAndPlayers] = []
    @State var selectedValue = LeagueAndPlayers(league: League(), players: [])
    @EnvironmentObject var dataStore: DataStore
    
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
                            .padding()
                    }
                    ForEach(players, id: \.self) { player in
                        NavigationLink(destination: PlayerDetailView(player: player).environmentObject(DataStore.shared)) {
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
            }
        }.onAppear() {
            _ = LCObject.fetch(dataStore.players, completion: { (result) in
                switch result {
                case .success:
                    self.orderData()
                    break
                case .failure(error: let error):
                    print(error)
                }
            })
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
    
    func orderData() {
        data = []
        for league in dataStore.leagues {
            var playerArray: [Player] = []
            for player in dataStore.players {
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
