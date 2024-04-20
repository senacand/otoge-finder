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
    @ObservableState
    struct State: Equatable {
        var searchText: String = ""
        var searchResult: [MKMapItem] = []
        var isLoading: Bool = false
        var isTextFieldFocused: Bool = false
        
        var isCancelButtonShown: Bool {
            isTextFieldFocused || !searchText.isEmpty
        }
    }
    
    enum Action {
        case searchTextChanged(String)
        case currentLocationTapped
        case searchCurrentAreaTapped
        case mapItemTapped(MKMapItem)
        case textFieldFocusChanged(Bool)
        case searchSubmitted
        case searchResponse([MKMapItem])
        case expandDetent
        case collapseDetent
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .searchTextChanged(let text):
                state.searchText = text
                
            case .textFieldFocusChanged(let focus):
                state.isTextFieldFocused = focus
                if focus == false && state.searchText.isEmpty {
                    state.searchResult = []
                }
                
            case .searchSubmitted:
                guard !state.searchText.isEmpty else {
                    return .none
                }
                
                return .run { [searchText = state.searchText] send in
                    let request = MKLocalSearch.Request()
                    request.naturalLanguageQuery = searchText
                    request.resultTypes = .address
                    
                    guard let response = try? await MKLocalSearch(request: request).start() else {
                        return
                    }
                    
                    await send(.searchResponse(response.mapItems))
                }
                
            case .searchResponse(let mapItems):
                state.searchResult = mapItems
                
            case .currentLocationTapped,
                 .searchCurrentAreaTapped,
                 .expandDetent,
                 .collapseDetent,
                 .mapItemTapped:
                break
            }
            
            return .none
        }
    }
}
