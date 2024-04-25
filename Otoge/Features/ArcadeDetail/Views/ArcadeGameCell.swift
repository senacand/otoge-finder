//
//  ArcadeGameCell.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import SwiftUI

struct ArcadeGameCell: View {
    @Environment(\.openURL) private var openURL
    
    let game: Game
    
    var body: some View {
        Button {
            guard let url = game.url else {
                return
            }
            openURL(url)
        }
        label: {
            HStack {
                if let image = game.image {
                    Image(asset: image)
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
            .contentShape(Rectangle())
            .padding(.vertical, 4.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ArcadeGameCell(game: .maimaiDx)
}
