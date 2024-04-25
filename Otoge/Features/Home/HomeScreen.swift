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
        ZStack(alignment: .topLeading) {
            mapView
            .searchSheet(homeStore: $store)
        }
    }
}

private extension HomeScreen {
    var mapView: some View {
        Map(
            position: $store
                .mapCameraPosition
                .sending(\.mapCameraPositionChanged),
            selection: $store
                .selectedArcade
                .sending(\.arcadeSelected)
        ) {
            if let searchedArea = store.searchedArea {
                Marker(
                    "",
                    systemImage: "magnifyingglass",
                    coordinate: searchedArea.coordinate
                )
                .tint(.white)
            }
            
            ForEach(store.arcades, id: \.self) { arcade in
                ArcadeAnnotation(
                    arcade: arcade,
                    isSelected: arcade == store.selectedArcade
                )
            }
        }
        .animation(.snappy, value: store.mapCameraPosition)
        .mapControls {
            MapCompass()
            MapUserLocationButton()
            MapScaleView()
        }
        .onAppear {
            store.send(.onAppear)
        }
        .mapStyle(.standard(elevation: .realistic))
        .onMapCameraChange { context in
            store.send(.mapCameraUpdated(context))
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

private extension View {
    func arcadeDetailSheet(
        homeStore: Bindable<StoreOf<HomeFeature>>
    ) -> some View {
        let sheet = self.sheet(
            item: homeStore.scope(
                state: \.arcadeDetailState,
                action: \.arcadeDetailAction
            )
        ) { store in
            NavigationStack {
                ArcadeDetailScreen(store: store)
            }
            .presentationDetents([.height(250), .fraction(0.99)])
            .presentationDragIndicator(.automatic)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
        }
        
        return sheet
    }
    
    func searchResultSheet(
        homeStore: Bindable<StoreOf<HomeFeature>>
    ) -> some View {
        let sheet = self.sheet(
            item:
                homeStore.scope(
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
            .arcadeDetailSheet(
                homeStore: homeStore
            )
        }
        
        return sheet
    }
    
    func searchSheet(
        homeStore: Bindable<StoreOf<HomeFeature>>
    ) -> some View {
        let sheet = self.sheet(
            item:
                homeStore.scope(
                    state: \.searchState,
                    action: \.searchAction
                )
        ) { searchStore in
            NavigationStack {
                SearchScreen(store: searchStore)
            }
            .presentationDetents([.height(120), .fraction(0.99)], selection: homeStore.searchDetent.sending(\.searchDetentUpdated))
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
            .searchResultSheet(homeStore: homeStore)
        }
        
        return sheet
    }
}

