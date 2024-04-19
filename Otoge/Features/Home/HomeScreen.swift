//
//  HomeScreen.swift
//  otoge
//
//  Created by Sen on 2024/4/19.
//

import ComposableArchitecture
import MapKit
import SwiftUI

struct HomeScreen: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        Map(
            position: $store
                .mapCameraPosition
                .sending(\.mapCameraPositionChanged)
        ) {
            ForEach(store.arcades, id: \.self) { arcade in
                Marker(
                    arcade.alternateName,
                    systemImage: "gamecontroller.fill",
                    coordinate:
                        CLLocationCoordinate2D(
                            latitude: arcade.location.latitude,
                            longitude: arcade.location.longitude
                        )
                )
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .onMapCameraChange { context in
            store.send(.mapRegionChanged(context.region))
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                
                if store.isLoading {
                    ProgressView()
                        .padding(.top)
                }
                else {
                    Button("Find Arcade Nearby", systemImage: "magnifyingglass") {
                        store.send(.searchTapped)
                    }
                    .padding(.top)
                }
                
                Spacer()
            }
            .background(.thinMaterial)
            .background(ignoresSafeAreaEdges: .all)
        }
        .sheet(
            item:
                $store.scope(
                    state: \.arcadeDetailState,
                    action: \.arcadeDetailAction
                )
        ) { arcadeDetailStore in
            ArcadeDetailScreen(store: arcadeDetailStore)
        }
    }
}

#Preview {
    HomeScreen(
        store: 
            Store(initialState: HomeFeature.State()) {
                HomeFeature()
            }
    )
}

