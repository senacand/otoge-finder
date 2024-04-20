//
//  LocalArcadeRepository.swift
//  Otoge
//
//  Created by Sen on 2024/4/21.
//

import ConcurrencyExtras
import Foundation
import MapKit

final class LocalArcadeRepository: ArcadeRepositoryProtocol {
    private var arcades: [Arcade] = []
    private lazy var arcadeUpdated: AsyncStream<Void> = {
        AsyncStream<Void> { [weak self] cont in
            self?._arcadeUpdatedCont = cont
        }
    }()
    
    private var _arcadeUpdatedCont: AsyncStream<Void>.Continuation?
    
    init() {
        Task {
            await loadArcadeLists()
        }
    }
    
    private func loadArcadeLists() async {
        if let path = Bundle.main.path(forResource: "jp_arcade_list", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let arcades = try decoder.decode([OtogeArcade].self, from: data)
                self.arcades =
                    arcades
                    .map(Arcade.init(arcade:))
                
                _arcadeUpdatedCont?.yield()
                
                debugPrint("Loading \(arcades.count)")
            } catch {
                debugPrint("Error loading!")
            }
        }
        else {
            debugPrint("File not found")
        }
    }
    
    func getArcadesByPosition(latitude: Double, longitude: Double) async -> [Arcade] {
        if arcades.isEmpty {
            // If has not finished loading, wait until it finishes.
            await arcadeUpdated.first { true }
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        return await
            getArcadesByPosition(
                latitude: latitude,
                longitude: longitude,
                distanceMultiplier: 1
            )
            .sorted {
                location.distance(from: $0.location.location)
                    < location.distance(from: $1.location.location)
            }
    }
    
    private func getArcadesByPosition(
        latitude: Double,
        longitude: Double,
        distanceMultiplier: Int
    ) async -> [Arcade] {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let result =
            arcades
            .filter { arcade in
                return 
                    location
                    .distance(
                        from: arcade.location.location
                    ) < (1000 * Double(distanceMultiplier))
            }
        
        guard (result.count < 1 && distanceMultiplier < 100)
                || (result.count < 3 && distanceMultiplier < 10)
                || (result.count < 5 && distanceMultiplier < 5)
                || (result.count < 10 && distanceMultiplier < 3)
        else {
            return result
        }
        
        return await getArcadesByPosition(
            latitude: latitude,
            longitude: longitude,
            distanceMultiplier: distanceMultiplier + 1
        )
    }
}

private extension Location {
    var location: CLLocation {
        CLLocation(
            latitude: latitude,
            longitude: longitude
        )
    }
}
