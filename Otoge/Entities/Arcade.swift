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
    
    init(name: String, alternateName: String? = nil, location: Location, games: [Game], brand: ArcadeBrand? = nil) {
        self.name = name
        self.alternateName = alternateName
        self.location = location
        self.games = games
            .sorted { $0.priority < $1.priority }
        self.brand = brand
    }
}

extension Arcade: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.latitude)
        hasher.combine(location.longitude)
    }
}
