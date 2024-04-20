//
//  SearchResultFeature.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import ComposableArchitecture

@Reducer
struct SearchResultFeature {
    @ObservableState
    struct State: Equatable {
        var arcades: [Arcade] = []
    }
    
    enum Action {
        case arcadeTapped(Arcade)
        case dismiss
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .arcadeTapped, .dismiss:
                break
            }
            
            return .none
        }
    }
}
