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
                .sending(\.mapCameraPositionChanged),
            selection: $store
                .selectedArcade
                .sending(\.arcadeSelected)
        ) {
            ForEach(store.arcades, id: \.self) { arcade in
                Marker(
                    arcade.name,
                    systemImage: "mappin",
                    coordinate:
                        CLLocationCoordinate2D(
                            latitude: arcade.location.latitude,
                            longitude: arcade.location.longitude
                        )
                )
                .tag(arcade)
            }
        }
        .animation(.snappy, value: store.mapCameraPosition)
        .mapControls {
            MapCompass()
            MapUserLocationButton()
        }
        .onAppear {
            store.send(.onAppear)
        }
        .mapStyle(.standard(elevation: .realistic))
        .onMapCameraChange { context in
            store.send(.mapCameraUpdated(context))
        }
        .sheet(
            item:
                $store.scope(
                    state: \.searchState,
                    action: \.searchAction
                )
        ) { searchStore in
            NavigationStack {
                SearchScreen(store: searchStore)
            }
            .presentationDetents([.height(100), .fraction(0.99)], selection: $store.searchDetent.sending(\.searchDetentUpdated))
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
            .sheet(
                item:
                    $store.scope(
                        state: \.searchResultState,
                        action: \.searchResultAction
                    )
            ) { searchResultStore in
                NavigationStack {
                    SearchResultScreen(store: searchResultStore)
                }
                .presentationDetents([.height(200), .height(350), .fraction(0.99)])
                .presentationDragIndicator(.automatic)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
                .sheet(
                    item:
                        $store.scope(
                            state: \.arcadeDetailState,
                            action: \.arcadeDetailAction
                        )
                ) { store in
                    NavigationStack {
                        ArcadeDetailScreen(store: store)
                    }
                    .presentationDetents([.height(350), .fraction(0.99)])
                    .presentationDragIndicator(.automatic)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
                }
            }
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

