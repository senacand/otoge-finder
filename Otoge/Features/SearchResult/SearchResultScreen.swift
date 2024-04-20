//
//  SearchResultScreen.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import ComposableArchitecture
import SwiftUI

struct SearchResultScreen: View {
    let store: StoreOf<SearchResultFeature>
    
    var body: some View {
        List {
            titleSection
                .padding(.top, 8.0)
            Section {
                ForEach(store.arcades, id: \.self) { arcade in
                    Button {
                        store.send(.arcadeTapped(arcade))
                    } label: {
                        HStack(alignment: .top, spacing: 16.0) {
                            if let brandImageString = arcade.brand?.imageString {
                                Image(uiImage: UIImage(named: brandImageString)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                            }
                            else {
                                Image(systemName: "mappin.and.ellipse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                            }
                            VStack(alignment: .leading) {
                                Text(arcade.name)
                                Text(arcade.location.address)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

extension SearchResultScreen {
    private var titleSection: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Arcades")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(store.arcades.count) found")
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    store.send(.dismiss)
                } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.bold)
                        .padding(.all, 8.0)
                        .background(.quaternary)
                        .foregroundStyle(.gray)
                        .clipShape(Circle())
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SearchResultScreen(
        store: Store(
            initialState: 
                SearchResultFeature.State(
                    arcades: [
                        Arcade(
                            name: "Arcade",
                            location: Location(
                                latitude: 0,
                                longitude: 0,
                                address: "Address"
                            ),
                            games: []
                        ),
                        Arcade(
                            name: "Arcade",
                            location: Location(
                                latitude: 0,
                                longitude: 0,
                                address: "Address"
                            ),
                            games: []
                        )
                    ]
                )
        ) {
            SearchResultFeature()
        }
    )
}
