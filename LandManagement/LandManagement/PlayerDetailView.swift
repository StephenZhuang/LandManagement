//
//  PlayerDetailView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/20.
//

import SwiftUI

struct PlayerDetailView: View {
    var player: Player
//    @State private var name = player.name.stringValue!
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player(objectId: "5fab8b1c7f22434137f48d1b")
        PlayerDetailView(player: player)
    }
}
