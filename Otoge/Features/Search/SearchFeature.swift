//
//  SearchFeature.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import ComposableArchitecture
import MapKit

@Reducer
struct SearchFeature {
    @Dependency(\.appLocalSearchRepository) var localSearchRepository
    
    @ObservableState
    struct State: Equatable {
        var hasAppeared: Bool = false
        
        var searchText: String = ""
        var searchCompletionResult: [MKLocalSearchCompletion] = []
        var isLoading: Bool = false
        var isTextFieldFocused: Bool = false
        
        var isCancelButtonShown: Bool {
            isTextFieldFocused || !searchText.isEmpty
        }
        
        var isMapsInCurrentLocation: Bool = true
    }
    
    enum Action {
        case onAppear
        case searchTextChanged(String)
        case currentLocationTapped
        case searchCurrentAreaTapped
        case textFieldFocusChanged(Bool)
        case searchCompleterResponse([MKLocalSearchCompletion])
        case searchCompletionTapped(MKLocalSearchCompletion)
        
        case expandDetent
        case collapseDetent
        case goToMapItem(MKMapItem)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.hasAppeared else { return .none }
                state.hasAppeared = true
                
                return .run { send in
                    for await completerResults in localSearchRepository.completerResults {
                        await send(.searchCompleterResponse(completerResults))
                    }
                }
                
            case .searchTextChanged(let text):
                state.searchText = text
                if text.isEmpty {
                    state.isLoading = false
                    state.searchCompletionResult = []
                }
                localSearchRepository.autocompleteWithSearchQuery(text)
                
            case .searchCompleterResponse(let completion):
                state.searchCompletionResult = completion
                
            case .textFieldFocusChanged(let focus):
                state.isTextFieldFocused = focus
                if focus == false && state.searchText.isEmpty {
                    state.searchCompletionResult = []
                }
                
            case .searchCompletionTapped(let completion):
                state.isTextFieldFocused = false
                state.isLoading = true
                
                return .run { send in
                    let result = await localSearchRepository
                        .searchLocationWithQuery(
                            [
                                completion.title,
                                completion.subtitle
                            ]
                            .joined(separator: " ")
                        )
                    
                    guard let mapItem = result.first else {
                        return
                    }
                    
                    await send(.goToMapItem(mapItem))
                }
                
            case .currentLocationTapped,
                 .searchCurrentAreaTapped,
                 .expandDetent,
                 .collapseDetent,
                 .goToMapItem:
                break
            }
            
            return .none
        }
    }
}
