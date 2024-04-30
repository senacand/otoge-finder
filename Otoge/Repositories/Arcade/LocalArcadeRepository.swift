//
//  LocalArcadeRepository.swift
//  Otoge
//
//  Created by Sen on 2024/4/21.
//

import ConcurrencyExtras
import Foundation
import MapKit

// TODO: Would be nice if we can use the app Arcade model directly in the JSON file instead of using Otoge.app's model and converting it into the Arcade model. Need to create own fetch script.

final class LocalArcadeRepository {
    struct SearchLimit {
        var maxDistance: CLLocationDistance
        var minArcadeCount: Int
    }
    
    private let searchLimits: [SearchLimit] = [
        .init(maxDistance: 2000, minArcadeCount: 5),
        .init(maxDistance: 3000, minArcadeCount: 3),
        .init(maxDistance: 5000, minArcadeCount: 2),
        .init(maxDistance: 30000, minArcadeCount: 1)
    ]
    
    private var arcades: [Arcade] = []
    
    private lazy var arcadeUpdated: AsyncStream<Void> = {
        AsyncStream<Void> { [weak self] cont in
            self?._arcadeUpdatedCont = cont
        }
    }()
    
    private var _arcadeUpdatedCont: AsyncStream<Void>.Continuation?
    
    private enum Country {
        case japan
        case indonesia
        
        var arcadeListFile: String {
            switch self {
            case .japan:
                return "jp_arcade_list"
            case .indonesia:
                return "id_arcade_list"
            }
        }
    }
    
    init() {
        Task {
            let arcades = 
                await [
                    loadArcadeLists(country: .japan),
                    loadArcadeLists(country: .indonesia)
                ]
                .flatMap { $0 }
            
            await MainActor.run {
                self.arcades = arcades
                _arcadeUpdatedCont?.yield()
            }
        }
    }
    
    private func loadArcadeLists(country: Country) async -> [Arcade] {
        if let path = Bundle.main.path(
            forResource: country.arcadeListFile, ofType: "json"
        ) {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let arcades = try decoder.decode([OtogeArcade].self, from: data)
                
                debugPrint("Loaded \(arcades.count) for \(country)")
                
                return arcades
                    .map(Arcade.init(arcade:))
                
            } catch {
                debugPrint("Error loading!")
            }
        }
        else {
            debugPrint("File not found")
        }
        
        return []
    }
}

extension LocalArcadeRepository: ArcadeRepositoryProtocol {
    func getArcadesByPosition(latitude: Double, longitude: Double) async -> [Arcade] {
        if arcades.isEmpty {
            // If has not finished loading, wait until it finishes.
            await arcadeUpdated.first { true }
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let searchLimits = searchLimits.sorted { $0.maxDistance < $1.maxDistance }
        let maxDistance = searchLimits.last?.maxDistance ?? 0
        
        let initialResults =
            arcades
            .map {
                ($0, location.distance(from: $0.location.location))
            }
            .filter { $0.1 < maxDistance }
            .sorted { $0.1 < $1.1 }
        
        var currentSearchLimitIndex = 0
        var previousDistance: CLLocationDistance = 0
        var arcades: [Arcade] = []
        
        // Logic:
        // 1. Search all arcades <1000m of location.
        // 2. If at least searchLimit's minArcadeCount amount of arcades is found, return.
        // 3. Else, increase the radius by 1000m and search all arcades within that area.
        // 4. Repeat (2)
        
        for result in initialResults {
            let (arcade, distance) = result
            
            while let currentSearchLimit = searchLimits[safe: currentSearchLimitIndex],
                  distance > currentSearchLimit.maxDistance {
                currentSearchLimitIndex += 1
            }
            
            guard let currentSearchLimit = searchLimits[safe: currentSearchLimitIndex] else {
                break
            }
            
            guard Int(distance / 1000) <= Int(previousDistance / 1000)
                    || arcades.count < currentSearchLimit.minArcadeCount else {
                break
            }
            
            previousDistance = distance
            arcades.append(arcade)
        }
        
        return arcades
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
        
        guard (result.count < 1 && distanceMultiplier < 30)
                || (result.count < 3 && distanceMultiplier < 10)
                || (result.count < 5 && distanceMultiplier < 3)
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

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
