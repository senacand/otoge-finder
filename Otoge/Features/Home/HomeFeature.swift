//
//  HomeReducer.swift
//  otoge
//
//  Created by Sen on 2024/4/19.
//

import ComposableArchitecture
import ComposableCoreLocation
import MapKit
import _MapKit_SwiftUI
import SwiftUI

@Reducer
struct HomeFeature {
    @Dependency(\.appLocationManager) var locationManager
    @Dependency(\.appArcadeRepository) var repository
    
    @ObservableState
    struct State: Equatable {
        var mapCameraPosition: MapCameraPosition =
            .userLocation(
                fallback: .camera(
                    MapCamera(
                        centerCoordinate: .init(
                            latitude: 35.73025258081452,
                            longitude: 139.71091455787956
                        ),
                        distance: 3000
                    )
                )
            )
        
        var mapCenter = MapCenter()
        var selectedArcade: Arcade?
        var arcades: [Arcade] = []
        var locationAuthorisationStatus: CLAuthorizationStatus = .notDetermined
        var hasAppeared: Bool = false
        var searchedArea: CLLocation?
        
        @Presents var arcadeDetailState: ArcadeDetailFeature.State?
        @Presents var searchState: SearchFeature.State?
        @Presents var searchResultState: SearchResultFeature.State?
        
        var searchDetent: PresentationDetent = .height(120)
    }
    
    struct MapCenter: Equatable {
        var latitude: CLLocationDegrees
        var longitude: CLLocationDegrees
        var spanDeltaLatitude: CLLocationDegrees
        var spanDeltaLongitude: CLLocationDegrees
        var distance: Double
        var pitch: Double
        var heading: Double
        
        init(_ context: MapCameraUpdateContext) {
            latitude = context.region.center.latitude
            longitude = context.region.center.longitude
            spanDeltaLatitude = context.region.span.latitudeDelta
            spanDeltaLongitude = context.region.span.longitudeDelta
            distance = context.camera.distance
            pitch = context.camera.pitch
            heading = context.camera.heading
        }
        
        init() {
            latitude = 0
            longitude = 0
            spanDeltaLatitude = 0
            spanDeltaLongitude = 0
            distance = 0
            pitch = 0
            heading = 0
        }
        
        var coordinate: CLLocation {
            .init(latitude: latitude, longitude: longitude)
        }
    }
    
    enum Action {
        case onAppear
        
        // Global Actions
        
        case arcadeListUpdated(arcades: [Arcade])
        case arcadeSelected(arcade: Arcade?)
        case mapCameraPositionChanged(MapCameraPosition)
        case mapCameraUpdated(MapCameraUpdateContext)
        
        // Location Manager
        
        case locationManagerAction(LocationManager.Action)
        
        // Sheet Screens
        
        case searchAction(PresentationAction<SearchFeature.Action>)
        case searchDetentUpdated(PresentationDetent)
        
        case searchResultAction(PresentationAction<SearchResultFeature.Action>)
        case arcadeDetailAction(PresentationAction<ArcadeDetailFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.hasAppeared else {
                    return .none
                }
                
                state.hasAppeared = true
                state.searchState = .init()
                
                return .merge(
                    .run { send in
                        for await action in await locationManager.delegate() {
                            await send(.locationManagerAction(action))
                        }
                    },
                    .run { send in
                        await locationManager.requestWhenInUseAuthorization()
                    }
                )
                
            case .mapCameraPositionChanged(let position):
                state.mapCameraPosition = position
                state.searchState?.isMapsInCurrentLocation =
                    position
                    .followsUserLocation
                
            case .mapCameraUpdated(let context):
                state.mapCenter = MapCenter(context)
                
            case .arcadeListUpdated(let arcades):
                state.arcades = arcades
                state.searchState?.isLoading = false
                state.searchResultState = .init(arcades: arcades)
                
                return .run { send in
                    await send(.mapCameraPositionChanged(.automatic))
                }
                
            case .arcadeSelected(let arcade):
                state.selectedArcade = arcade
                if let arcade {
                    state.arcadeDetailState = .init(arcade: arcade)
                    return .run { [mapCenter = state.mapCenter] send in
                        await send(
                            .mapCameraPositionChanged(
                                .camera(
                                    MapCamera(
                                        centerCoordinate:
                                            CLLocationCoordinate2D(
                                                latitude: arcade.location.latitude,
                                                longitude: arcade.location.longitude
                                            ),
                                        distance: mapCenter.distance,
                                        heading: mapCenter.heading,
                                        pitch: mapCenter.pitch
                                    )
                                )
                            )
                        )
                    }
                }
                else {
                    state.arcadeDetailState = nil
                }
                
            case .arcadeDetailAction(.presented(.dismiss)),
                .arcadeDetailAction(.dismiss):
                state.arcadeDetailState = nil
                state.selectedArcade = nil
                
            case .arcadeDetailAction:
                break
                
            case .locationManagerAction:
                break
                
            case .searchAction(.presented(.searchCurrentAreaTapped)):
                state.searchState?.isLoading = true
                state.searchedArea = state.mapCenter.coordinate
                return .run { [mapCenter = state.mapCenter] send in
                    let arcades = await repository.getArcadesByPosition(
                        latitude: mapCenter.latitude,
                        longitude: mapCenter.longitude
                    )
                    
                    await send(
                        .arcadeListUpdated(
                            arcades: arcades
                        )
                    )
                }
                
            case .searchAction(.presented(.goToMapItem(let mapItem))):
                state.searchState?.isLoading = true
                state.searchedArea = .init(
                    latitude: mapItem.placemark.coordinate.latitude,
                    longitude: mapItem.placemark.coordinate.longitude
                )
                
                return .run { send in
                    let arcades = await repository.getArcadesByPosition(
                        latitude: mapItem.placemark.coordinate.latitude,
                        longitude: mapItem.placemark.coordinate.longitude
                    )
                    
                    await send(
                        .arcadeListUpdated(
                            arcades: arcades
                        )
                    )
                }
                
            case .searchAction(.presented(.expandDetent)):
                state.searchDetent = .fraction(0.99)
                
            case .searchAction(.presented(.collapseDetent)):
                state.searchDetent = .height(120)
                
            case .searchDetentUpdated(let detent):
                state.searchDetent = detent
                
            case .searchResultAction(.presented(.arcadeTapped(let arcade))):
                return .run { send in
                    await send(.arcadeSelected(arcade: arcade))
                }
                
            case .searchResultAction(.dismiss),
                 .searchResultAction(.presented(.dismiss)):
                state.arcades = []
                state.searchResultState = nil
                state.searchedArea = nil
                
                if !(state.searchState?.searchText.isEmpty ?? true) {
                    state.searchState?.isTextFieldFocused = true
                }
                
            case .searchResultAction:
                break
                
            case .searchAction:
                break
            }
            
            return .none
        }
        .ifLet(\.$arcadeDetailState, action: \.arcadeDetailAction) {
            ArcadeDetailFeature()
        }
        .ifLet(\.$searchState, action: \.searchAction) {
            SearchFeature()
        }
        .ifLet(\.$searchResultState, action: \.searchResultAction) {
            SearchResultFeature()
        }
    }
}
