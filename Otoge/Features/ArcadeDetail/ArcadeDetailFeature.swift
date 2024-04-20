//
//  ArcadeDetailFeature.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

import ComposableArchitecture

@Reducer
struct ArcadeDetailFeature {
    @ObservableState
    struct State: Equatable {
        let arcade: Arcade
        
        var isAlternateAddress = false
        var isMapsSelectionActionSheetShown = false
    }
    
    enum Action {
        case dismiss
        case toggleAlternateAddress
        case mapsSelectionActionSheetShown(Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .dismiss:
                break
            case .toggleAlternateAddress:
                state.isAlternateAddress = !state.isAlternateAddress
            case .mapsSelectionActionSheetShown(let shown):
                state.isMapsSelectionActionSheetShown = shown
            }
            
            return .none
        }
    }
}
