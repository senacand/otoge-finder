//
//  Arcade.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

struct Arcade: Equatable {
    var name: String
    var alternateName: String?
    var location: Location
    var games: [Game]
    var brand: ArcadeBrand?
}

extension Arcade: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.latitude)
        hasher.combine(location.longitude)
    }
}
