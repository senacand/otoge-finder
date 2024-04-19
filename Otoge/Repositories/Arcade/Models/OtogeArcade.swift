//
//  OtogeArcade.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

import Foundation

struct OtogeArcade: Codable {
    var country, area, storeName, address: String
    var alternateArea, alternateStoreName, alternateAddress: String?
    var lat, lng: Double
    var access, openingHours: String?
    var cabinets: [OtogeCabinet]
    var brand: String?
}
