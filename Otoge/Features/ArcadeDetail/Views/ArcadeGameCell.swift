//
//  ArcadeGameCell.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import SwiftUI

struct ArcadeGameCell: View {
    let game: Game
    
    var body: some View {
        HStack {
            Image(systemName: "gamecontroller.fill")
            Text(game.name)
            Spacer()
        }
        .padding(.vertical, 4.0)
    }
}

#Preview {
    ArcadeGameCell(game: .maimaiDx)
}
