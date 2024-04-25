//
//  ArcadeAnnotation.swift
//  OtogeFinder
//
//  Created by Sen on 2024/4/26.
//

import SwiftUI
import _MapKit_SwiftUI

struct ArcadeAnnotation: MapContent {
    let arcade: Arcade
    let isSelected: Bool
    
    var body: some MapContent {
        if let brandImage = arcade.brand?.image {
            Annotation(
                arcade.name,
                coordinate:
                    .init(
                        latitude: arcade.location.latitude,
                        longitude: arcade.location.longitude
                    ),
                anchor: .center
            ) {
                Image(asset: brandImage)
                    .resizable()
                    .frame(
                        width: isSelected ? 42 : 32,
                        height: isSelected ? 42 : 32
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .animation(.bouncy, value: isSelected)
            }
            .tag(arcade)
        }
        else {
            Marker(
                arcade.name,
                systemImage: "mappin",
                coordinate:
                        .init(
                            latitude: arcade.location.latitude,
                            longitude: arcade.location.longitude
                        )
            )
            .tag(arcade)
        }
    }
}
