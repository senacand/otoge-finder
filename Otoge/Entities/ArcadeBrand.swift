//
//  ArcadeBrand.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

import SwiftUI

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
    
    var image: ImageAsset {
        switch self {
        case .gigo:
            Asset.gigo
        case .taito:
            Asset.taito
        case .gamePanic:
            Asset.gamepanic
        case .namco:
            Asset.namco
        case .timezone:
            Asset.timezone
        case .leisureLand:
            Asset.leisureland
        case .roundOne:
            Asset.roundone
        case .joypolis:
            Asset.joypolis
        case .asoviba:
            Asset.asoviba
        case .cowPlayCowMoo:
            Asset.cpcm
        }
    }
}
