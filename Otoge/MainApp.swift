//
//  MainApp.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

import ComposableArchitecture
import ComposableCoreLocation
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen(
                store: Store(
                    initialState: HomeFeature.State()
                ) {
                    HomeFeature()
                }
            )
        }
    }
}

private enum AppArcadeRepository: DependencyKey {
    static let liveValue: ArcadeRepositoryProtocol = OtogeAppArcadeRepository()
}

private enum AppLocationManager: DependencyKey {
    static var liveValue: LocationManager = LocationManager.liveValue
}

extension DependencyValues {
    var appArcadeRepository: ArcadeRepositoryProtocol {
        get { self[AppArcadeRepository.self] }
        set { self[AppArcadeRepository.self] = newValue }
    }
    
    var appLocationManager: LocationManager {
        get { self[AppLocationManager.self] }
        set { self[AppLocationManager.self] = newValue }
    }
}
