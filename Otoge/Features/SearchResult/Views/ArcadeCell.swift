//
//  ArcadeCell.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import SwiftUI

struct ArcadeCell: View {
    let arcade: Arcade
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .top, spacing: 16.0) {
                if let brandImageString = arcade.brand?.imageString {
                    Image(uiImage: UIImage(named: brandImageString)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                else {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                }
                VStack(alignment: .leading) {
                    Text(arcade.name)
                    Text(arcade.location.address)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    let gameImages = arcade
                        .games
                        .filter {
                            // If SDVX Valkyrie exists, just show Valkyrie
                            !($0 == .soundVoltex && arcade.games.contains(.soundVoltexValkyrie))
                        }
                        .compactMap(\.imageString)
                    
                    if !gameImages.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(gameImages, id: \.hashValue) { image in
                                    Image(uiImage: UIImage(named: image)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        .onTapGesture {
                            action()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ArcadeCell(
        arcade: Arcade(
            name: "Arcade Name",
            alternateName: "Arcade Name",
            location: .init(latitude: 0, longitude: 0, address: "Address"),
            games: [
                .beatmaniaIidx,
                .chunithm,
                .danceDanceRevolution,
                .danceRushStardom,
                .gitadoraDrumMania,
                .gitadoraGuitarFreaks,
                .jubeat,
                .maimaiDx,
                .ongeki,
                .polarisChord,
                .popNMusic,
                .soundVoltex
            ],
            brand: .gigo
        ),
        action: {}
    )
}
