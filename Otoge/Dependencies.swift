//
//  Dependencies.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import ComposableArchitecture
import ComposableCoreLocation

private enum AppArcadeRepository: DependencyKey {
    static let liveValue: ArcadeRepositoryProtocol = LocalArcadeRepository()
}

private enum AppLocalSearchRepository: DependencyKey {
    static let liveValue: LocalSearchRepositoryProtocol = MKLocalSearchRepository()
}

private enum AppLocationManager: DependencyKey {
    static var liveValue: LocationManager = LocationManager.liveValue
}

extension DependencyValues {
    var appArcadeRepository: ArcadeRepositoryProtocol {
        get { self[AppArcadeRepository.self] }
        set { self[AppArcadeRepository.self] = newValue }
    }
    
    var appLocalSearchRepository: LocalSearchRepositoryProtocol {
        get { self[AppLocalSearchRepository.self] }
        set { self[AppLocalSearchRepository.self] = newValue }
    }
    
    var appLocationManager: LocationManager {
        get { self[AppLocationManager.self] }
        set { self[AppLocationManager.self] = newValue }
    }
}
