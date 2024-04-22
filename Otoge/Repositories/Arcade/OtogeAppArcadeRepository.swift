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
        components.host = "production.otoge-app.djzmo.workers.dev"
        components.path = "/\(path)"
        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        return components.url!
    }
}
