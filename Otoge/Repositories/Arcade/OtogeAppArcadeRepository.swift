//
//  OtogeAppArcadeRepository.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

import Alamofire
import Foundation

final class OtogeAppArcadeRepository: ArcadeRepositoryProtocol {
    func getArcadesByPosition(latitude: Double, longitude: Double) async -> [Arcade] {
        await AF
            .request(
                url(
                    forPath: "store/searchByPosition",
                    parameters: [
                        "lat": String(latitude),
                        "lng": String(longitude)
                    ]
                )
            )
            .serializingDecodable([OtogeArcade].self)
            .response
            .map {
                $0.map(Arcade.init(arcade:))
            }
            .value ?? []
    }
    
    private func url(forPath path: String, parameters: [String: String?]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "otoge.app"
        components.path = "/api/\(path)"
        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        return components.url!
    }
}

private extension Arcade {
    init(arcade: OtogeArcade) {
        self.init(
            name: arcade.storeName,
            alternateName: arcade.alternateStoreName,
            location: Location(
                latitude: arcade.lat,
                longitude: arcade.lng,
                address: arcade.address,
                alternateAddress: arcade.alternateAddress
            ),
            games: 
                Array(
                    Set(
                        arcade.cabinets.map {
                            Game(cabinet: $0)
                        }
                    )
                ),
            brand: ArcadeBrand.from(brand: arcade.brand)
        )
    }
}

private extension Game {
    init(cabinet: OtogeCabinet) {
        switch cabinet.game {
        case "CHUNITHM_NEW", "CHUNITHM_NEW_INTERNATIONAL":
            self = .chunithm
        case "MAIMAI_DX", "MAIMAI_DX_INTERNATIONAL":
            self = .maimaiDx
        case "ONGEKI":
            self = .ongeki
        case "BEATMANIA_IIDX", "BEATMANIA_IIDX_LIGHTNING_MODEL":
            self = .beatmaniaIidx
        case "DANCEDANCEREVOLUTION", "DANCEDANCEREVOLUTION_20TH_ANNIVERSARY_MODEL":
            self = .danceDanceRevolution
        case "DANCERUSH_STARDOM":
            self = .danceRushStardom
        case "GITADORA_DRUMMANIA":
            self = .gitadoraDrumMania
        case "GITADORA_GUITARFREAKS":
            self = .gitadoraGuitarFreaks
        case "HATSUNE_MIKU_PROJECT_DIVA_ARCADE":
            self = .projectDiva
        case "JUBEAT":
            self = .jubeat
        case "POP_N_MUSIC":
            self = .popNMusic
        case "SOUND_VOLTEX", "SOUND_VOLTEX_VALKYRIE_MODEL":
            self = .soundVoltex
        case "POLARIS_CHORD":
            self = .polarisChord
        default:
            self = .other(name: cabinet.game)
        }
    }
}

private extension ArcadeBrand {
    static func from(brand: String?) -> ArcadeBrand? {
        guard let brand else {
            return nil
        }
        
        switch brand {
        case "gigo":
            return .gigo
        case "taito":
            return .taito
        case "leisureland":
            return .leisureLand
        case "game-panic":
            return .gamePanic
        case "namco":
            return .namco
        case "round1":
            return .roundOne
        case "timezone":
            return .timezone
        default:
            return nil
        }
    }
}
