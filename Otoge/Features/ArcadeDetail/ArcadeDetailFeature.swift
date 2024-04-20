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
    }
    
    enum Action {
        case dismiss
        case toggleAlternateAddress
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .dismiss:
                break
            case .toggleAlternateAddress:
                state.isAlternateAddress = !state.isAlternateAddress
            }
            
            return .none
        }
    }
}
