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
        VStack(alignment: .center) {
            searchInput
                .padding(.top, 18)
                .padding(.horizontal)
            
            if !store.isLoading {
                if store.searchCompletionResult.isEmpty {
                    if !store.isCancelButtonShown {
                        if store.isMapsInCurrentLocation {
                            Button(
                                "Search around me",
                                systemImage: "location.magnifyingglass"
                            ) {
                                store.send(.searchCurrentAreaTapped)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8.0)
                        }
                        else {
                            Button(
                                "Search within this area",
                                systemImage: "doc.text.magnifyingglass"
                            ) {
                                store.send(.searchCurrentAreaTapped)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8.0)
                        }
                    }
                    Spacer()
                }
                else {
                    List {
                        Section {
                            ForEach(store.searchCompletionResult, id: \.self) { item in
                                Button {
                                    store.send(.searchCompletionTapped(item))
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                        Text(item.subtitle)
                                            .font(.caption)
                                    }
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
                    .frame(
                        maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                        maxHeight: .infinity,
                        alignment: .center
                    )
            }
        }
        .animation(.snappy, value: store.isMapsInCurrentLocation)
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    var searchInput: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .opacity(0.5)
                TextField(
                    "Search somewhere else",
                    text: $store.searchText.sending(\.searchTextChanged)
                )
                .focused($searchTextFieldFocus)
                .onSubmit {
                    store.send(.textFieldFocusChanged(false))
                }
                .bind(
                    $store
                        .isTextFieldFocused
                        .sending(\.textFieldFocusChanged),
                    to: $searchTextFieldFocus
                )
                if store.isClearTextFieldButtonShown {
                    Button {
                        store.send(.clearTextFieldTapped)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.all, 8.0)
            .background(.quinary)
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
        .animation(.snappy, value: store.isCancelButtonShown)
        .onChange(of: store.isTextFieldFocused) { _, isFocused in
            if isFocused {
                store.send(.expandDetent)
            }
        }
        .onChange(of: store.isCancelButtonShown) { _, shown in
            if !shown {
                store.send(.collapseDetent)
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
