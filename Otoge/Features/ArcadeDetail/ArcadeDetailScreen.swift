//
//  ArcadeDetailScreen.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

import ComposableArchitecture
import SwiftUI

struct ArcadeDetailScreen: View {
    let store: StoreOf<ArcadeDetailFeature>
    
    var body: some View {
        List {
            titleSection
                .listRowSeparator(.hidden)
                .padding(.vertical, 4.0)
            Section(header: Text("Game Cabinets")) {
                gamesSection
            }
        }
        .background(.regularMaterial)
        .listStyle(.plain)
    }
}

extension ArcadeDetailScreen {
    private var titleSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(store.arcade.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let alternateName = store.arcade.alternateName,
                    !alternateName.isEmpty
                {
                    Text(alternateName)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
                
                Text(store.arcade.location.address)
            }
            Spacer()
            Button {
                guard let url = store.arcade.location.appleMapsUrl else {
                    return
                }
                
                UIApplication.shared.open(url)
            } label: {
                Image(systemName: "map")
                    .fontWeight(.bold)
                    .padding(.all, 8.0)
                    .background(.quaternary)
                    .foregroundStyle(.gray)
                    .clipShape(Circle())
            }
            Button {
                store.send(.dismiss)
            } label: {
                Image(systemName: "xmark")
                    .fontWeight(.bold)
                    .padding(.all, 8.0)
                    .background(.quaternary)
                    .foregroundStyle(.gray)
                    .clipShape(Circle())
            }
        }
    }
    
    private var gamesSection: some View {
        ForEach(store.arcade.games, id: \.self) { game in
            ArcadeGameCell(game: game)
        }
    }
}

#Preview {
    ArcadeDetailScreen(
        store: Store(
            initialState: ArcadeDetailFeature.State(
                arcade: Arcade(
                    name: "ゲームセンターの名前",
                    alternateName: "Arcade Name",
                    location: Location(
                        latitude: 0,
                        longitude: 0,
                        address: "Address",
                        alternateAddress: "Address"
                    ),
                    games: [
                        .maimaiDx, 
                        .beatmaniaIidx, 
                        .chunithm,
                        .danceDanceRevolution,
                        .danceRushStardom,
                        .gitadoraDrumMania,
                        .gitadoraGuitarFreaks,
                        .jubeat,
                        .ongeki,
                        .polarisChord,
                        .popNMusic,
                        .projectDiva,
                        .soundVoltex
                    ],
                    brand: .gigo
                )
            )
        ) {
            ArcadeDetailFeature()
        }
    )
}

private extension Location {
    var appleMapsUrl: URL? {
        URL(string: "maps://?daddr=\(latitude),\(longitude)")
    }
}
