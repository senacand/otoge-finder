//
//  ArcadeDetailScreen.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

import ComposableArchitecture
import SwiftUI

struct ArcadeDetailScreen: View {
    let store: StoreOf<ArcadeDetailFeature>
    
    var body: some View {
        Text("Hello, World!")
            .navigationBarTitle(Text(store.arcade.name))
    }
}

#Preview {
    NavigationStack {
        ArcadeDetailScreen(
            store: Store(
                initialState: ArcadeDetailFeature.State(
                    arcade: Arcade(
                        name: "Arcade Name",
                        alternateName: "Arcade Name",
                        location: Location(
                            latitude: 0,
                            longitude: 0,
                            address: "Address",
                            alternateAddress: "Address"
                        ),
                        games: [.maimaiDx],
                        brand: .gigo
                    )
                )
            ) {
                ArcadeDetailFeature()
            }
        )
    }
}
