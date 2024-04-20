//
//  SearchScreen.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import ComposableArchitecture
import SwiftUI

struct SearchScreen: View {
    @Bindable var store: StoreOf<SearchFeature>
    @FocusState var searchTextFieldFocus: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                searchInput
            }
            .padding(.top, 24)
            .padding(.horizontal)
            
            if !store.isLoading {
                if store.searchResult.isEmpty {
                    if !store.isCancelButtonShown {
                        Button {
                            store.send(.searchCurrentAreaTapped)
                        } label: {
                            HStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                Text("Search within this area")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 8.0)
                    }
                    Spacer()
                }
                else {
                    List {
                        Section {
                            ForEach(store.searchResult, id: \.self) { item in
                                Button(item.name ?? "") {
                                    store.send(.mapItemTapped(item))
                                }
                                .foregroundColor(.primary)
                            }
                        } header: {
                            Text("Matching Locations")
                        }
                    }
                    
                }
            }
            else {
                ProgressView()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .center)
            }
        }
    }
    
    var searchInput: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField(
                    "Search Maps",
                    text: $store.searchText.sending(\.searchTextChanged)
                )
                .focused($searchTextFieldFocus)
                .onSubmit {
                    store.send(.searchSubmitted)
                }
                .bind($store.isTextFieldFocused.sending(\.textFieldFocusChanged), to: $searchTextFieldFocus)
            }
            .padding(.all, 8.0)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            
            if store.isCancelButtonShown {
                Button("Cancel") {
                    store.send(.searchTextChanged(""))
                    store.send(.textFieldFocusChanged(false))
                    store.send(.collapseDetent)
                }
                .padding(.leading, 4.0)
            }
        }
        .onChange(of: store.searchResult) {
            if !store.searchResult.isEmpty {
                store.send(.expandDetent)
            }
        }
    }
}

#Preview {
    SearchScreen(
        store: Store(
            initialState: SearchFeature.State()
        ) {
            SearchFeature()
        }
    )
}
