//
//  OrganizationView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/13.
//

import SwiftUI
import LeanCloud

struct OrganizationView: View {
    private var selectedZone: Zone = Zone(objectId: AppUserDefaults.selectedZone)
    @State private var leagues: [League] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(leagues, id: \.self) { league in
                    NavigationLink(destination: PlayerList(league: league)) {
                        Text("\(league.serverId.intValue!) "+league.name.stringValue!)
                    }
                }
            }.listStyle(InsetGroupedListStyle())
        }.navigationBarTitle("盟列表")
        .onAppear() {
            if leagues.count <= 0 {
                self.fetchLeagues()
            }
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

                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
}

struct OrganizationView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationView()
    }
}
