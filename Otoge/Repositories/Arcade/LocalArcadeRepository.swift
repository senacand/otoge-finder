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
