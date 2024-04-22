//
//  ArcadeBrand.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

enum ArcadeBrand: Equatable {
    case gigo
    case taito
    case leisureLand
    case gamePanic
    case namco
    case roundOne
    case timezone
    case joypolis
    case asoviba
    case cowPlayCowMoo
    
    var imageString: String? {
        switch self {
        case .gigo:
            "gigo"
        case .taito:
            "taito"
        case .gamePanic:
            "gamepanic"
        case .namco:
            "namco"
        case .timezone:
            "timezone"
        case .leisureLand:
            "leisureland"
        case .roundOne:
            "roundone"
        case .joypolis:
            "joypolis"
        case .asoviba:
            "asoviba"
        case .cowPlayCowMoo:
            "cpcm"
        }
    }
}
