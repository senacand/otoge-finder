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
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 16.0) {
                    if let brandImage = arcade.brand?.image {
                        Image(asset: brandImage)
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
                    }
                }
                
                let gameImages = arcade
                    .games
                    .compactMap(\.image)
                    .unique
                
                if !gameImages.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(gameImages, id: \.name) { image in
                                Image(asset: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(.leading, 16 + 32 + 16)
                        .padding(.trailing, 16)
                    }
                    .scrollIndicators(.hidden)
                    .onTapGesture {
                        action()
                    }
                    .padding(.horizontal, -16)
                }
            }
        }
    }
}

extension ImageAsset: Equatable {
    static func == (lhs: ImageAsset, rhs: ImageAsset) -> Bool {
        lhs.name == rhs.name
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
