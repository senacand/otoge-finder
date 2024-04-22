//
//  ArcadeDetailScreen.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

import ComposableArchitecture
import SwiftUI

struct ArcadeDetailScreen: View {
    @Bindable var store: StoreOf<ArcadeDetailFeature>
    @Environment(\.openURL) private var openURL
    
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
        .confirmationDialog(
            "Which Maps app to use?",
            isPresented: $store
                .isMapsSelectionActionSheetShown
                .sending(\.mapsSelectionActionSheetShown)
        ) {
            Button("Apple Maps") { 
                guard let url = store.arcade.location.appleMapsUrl else {
                    return
                }
                UIApplication.shared.open(url)
            }
            Button("Google Maps") { 
                guard let url = store.arcade.location.googleMapsUrl else {
                    return
                }
                openURL(url)
            }
            
            Button("Cancel", role: .cancel) {
                store.send(.mapsSelectionActionSheetShown(false))
            }
        }
    }
}

extension ArcadeDetailScreen {
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text(store.arcade.name)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    store.send(.mapsSelectionActionSheetShown(true))
                } label: {
                    Image(systemName: "map")
                        .fontWeight(.medium)
                        .padding(.all, 8.0)
                        .background(.quaternary)
                        .foregroundStyle(.gray)
                        .clipShape(Circle())
                }
                Button {
                    store.send(.dismiss)
                } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.medium)
                        .padding(.all, 8.0)
                        .background(.quaternary)
                        .foregroundStyle(.gray)
                        .clipShape(Circle())
                }
            }
                
            if let alternateName = store.arcade.alternateName,
                !alternateName.isEmpty
            {
                Text(alternateName.capitalized)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 4.0)
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
    
    @ViewBuilder
    private var gamesSection: some View {
        VStack(alignment: .leading) {
            let games = store
                .arcade
                .games
                .filter {
                    // If SDVX Valkyrie exists, just show Valkyrie
                    !($0 == .soundVoltex && store.arcade.games.contains(.soundVoltexValkyrie))
                }
            
            ForEach(games, id: \.self) { game in
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
    
    var googleMapsUrl: URL? {
        URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)")
    }
}
