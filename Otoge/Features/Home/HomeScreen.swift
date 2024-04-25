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
    @State var mapTapped = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad 
            || UIDevice.current.userInterfaceIdiom == .mac
            || UIDevice.current.userInterfaceIdiom == .vision
        {
            iPadLayout
        }
        else {
            iPhoneLayout
        }
    }
}

private extension HomeScreen {
    var iPhoneLayout: some View {
        mapView
            .searchSheet(homeStore: $store)
    }
    
    var iPadLayout: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                mapView
                .onMapCameraChange(frequency: .continuous) {
                    mapTapped = true
                }
                .onMapCameraChange(frequency: .onEnd) {
                    mapTapped = false
                }
                ZStack {
                    if let store = $store.scope(
                        state: \.arcadeDetailState,
                        action: \.arcadeDetailAction
                    ).wrappedValue
                    {
                        ArcadeDetailScreen(
                            store: store
                        )
                        .transition(
                            .move(edge: .bottom)
                        )
                    }
                    
                    else if let store = $store.scope(
                        state: \.searchResultState,
                        action: \.searchResultAction
                    ).wrappedValue
                    {
                        SearchResultScreen(
                            store: store
                        )
                        .transition(
                            .move(edge: .bottom)
                        )
                    }
                    
                    else if let store = $store.scope(
                        state: \.searchState,
                        action: \.searchAction
                    ).wrappedValue
                    {
                        VStack {
                            Text("OTOGE")
                                .font(Font.custom("Nabla", size: 48.0))
                                .padding(.bottom, -18)
                            SearchScreen(
                                store: store
                            )
                        }
                        .transition(
                            .move(edge: .bottom)
                        )
                    }
                }
                .padding(.all, 4.0)
                .background(.thinMaterial)
                .frame(
                    width: 360,
                    height: 460
                )
                .clipShape(RoundedRectangle(cornerRadius: 24.0))
                .padding(.leading, 16.0)
                .opacity(mapTapped ? 0.3 : 1.0)
                .animation(
                    .smooth,
                    value: mapTapped
                )
                .animation(.smooth, value: store.searchResultState)
                .animation(.smooth, value: store.arcadeDetailState)
            }
        }
    }
    
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

