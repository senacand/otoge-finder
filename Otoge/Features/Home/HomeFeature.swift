//
//  HomeReducer.swift
//  otoge
//
//  Created by Sen on 2024/4/19.
//

import ComposableArchitecture
import MapKit
import _MapKit_SwiftUI

@Reducer
struct HomeFeature {
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
        
        var mapCenter = MapCenter(.init())
        var selectedArcade: Arcade?
        var arcades: [Arcade] = []
        var isLoading = false
        
        @Presents var arcadeDetailState: ArcadeDetailFeature.State?
    }
    
    struct MapCenter: Equatable {
        var latitude: CLLocationDegrees
        var longitude: CLLocationDegrees
        var spanDeltaLatitude: CLLocationDegrees
        var spanDeltaLongitude: CLLocationDegrees
        
        init(_ region: MKCoordinateRegion) {
            latitude = region.center.latitude
            longitude = region.center.longitude
            spanDeltaLatitude = region.span.latitudeDelta
            spanDeltaLongitude = region.span.longitudeDelta
        }
    }
    
    enum Action {
        case searchTapped
        case arcadeListUpdated(arcades: [Arcade])
        case arcadeSelected(arcade: Arcade?)
        case arcadeDetailAction(PresentationAction<ArcadeDetailFeature.Action>)
        case mapCameraPositionChanged(MapCameraPosition)
        case mapRegionChanged(MKCoordinateRegion)
    }
    
    let repository: ArcadeRepositoryProtocol = OtogeAppArcadeRepository()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .mapCameraPositionChanged(let position):
                state.mapCameraPosition = position
                
            case .mapRegionChanged(let region):
                state.mapCenter = MapCenter(region)
                
            case .searchTapped:
                state.isLoading = true
                return .run { [mapCenter = state.mapCenter] send in
                    let arcades = await repository.getArcadesByPosition(
                        latitude: mapCenter.latitude,
                        longitude: mapCenter.longitude
                    )
                    
                    await send(.arcadeListUpdated(arcades: arcades))
                }
                
            case .arcadeListUpdated(let arcades):
                state.arcades = arcades
                state.isLoading = false
                
            case .arcadeSelected(let arcade):
                state.selectedArcade = arcade
                if let arcade {
                    state.arcadeDetailState = .init(arcade: arcade)
                }
                else {
                    state.arcadeDetailState = nil
                }
                
            case .arcadeDetailAction(.presented(.dismiss)):
                state.arcadeDetailState = nil
                state.selectedArcade = nil
                
            case .arcadeDetailAction:
                break
            }
            
            return .none
        }
        .ifLet(\.$arcadeDetailState, action: \.arcadeDetailAction) {
            ArcadeDetailFeature()
        }
    }
}
