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
        ScrollView {
            LazyVStack(alignment: .leading) {
                titleSection
                    .listRowSeparator(.hidden)
                    .padding(.all)
                    .padding(.top, 4.0)
                gamesSection
                    .padding(.horizontal)
                    .padding(.vertical, 12.0)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
                    .padding(.horizontal)
            }
        }
    }
}

extension ArcadeDetailScreen {
    private var titleSection: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(store.arcade.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    guard let url = store.arcade.location.appleMapsUrl else {
                        return
                    }
                    #if os(iOS)
                    UIApplication.shared.open(url)
                    #endif
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
                
            if let alternateName = store.arcade.alternateName,
                !alternateName.isEmpty
            {
                Text(alternateName)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            }
            
            Text(
                store.isAlternateAddress
                ? store.arcade.location.alternateAddress ?? store.arcade.location.address
                : store.arcade.location.address
            )
            .onTapGesture {
                store.send(.toggleAlternateAddress)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var gamesSection: some View {
        LazyVStack(alignment: .leading) {
            ForEach(store.arcade.games, id: \.self) { game in
                ArcadeGameCell(game: game)
                if game != store.arcade.games.last {
                    Divider()
                }
            }
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
                        address: "所のアドレッス",
                        alternateAddress: "Alternate Address"
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
