//
//  MainApp.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

import ComposableArchitecture
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen(
                store: Store(
                    initialState: HomeFeature.State()
                ) {
                    HomeFeature()
                }
            )
        }
    }
}
