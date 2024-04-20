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
            if let imageString = game.imageString {
                Image(uiImage: UIImage(named: imageString)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            }
            else {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            }
            
            Text(game.name)
            Spacer()
        }
        .padding(.vertical, 4.0)
    }
}

#Preview {
    ArcadeGameCell(game: .maimaiDx)
}
