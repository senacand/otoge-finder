//
//  SettingsScreen.swift
//  OtogeFinder
//
//  Created by Sen on 2024/4/30.
//

import SwiftUI

struct SettingsScreen: View {
    @State var isEditing: EditMode = .active
    
    @State var navigationApp: String = "Apple Maps"
    var navigationApps = ["Apple Maps", "Google Maps"]
    
    @State var startLocation: String = "Your Location"
    var startLocations = ["Your Location", "Search Location"]
    
    @State var games: [Game] = [.maimaiDx, .chunithm, .danceDanceRevolution, .soundVoltex]
    
    var body: some View {
        List {
            Section("Text Display") {
                SettingsItemSwitch(title: "Use alternate name")
                SettingsItemSwitch(title: "Use alternate address")
            }
            
            Section("Navigate Mode") {
                Picker("Map App", selection: $navigationApp) {
                    ForEach(navigationApps, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.automatic)
                
                Picker("Start Location", selection: $startLocation) {
                    ForEach(startLocations, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.automatic)
            }
            
            Section {
                NavigationLink("Games List Priority") {
                    
                }
            }
            
            Section("Arcade Database") {
                HStack {
                    Text("Last Sync")
                    Spacer()
                    Text("12 February 2024")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Fetch Date")
                    Spacer()
                    Text("12 February 2024")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Active Arcades")
                    Spacer()
                    Text("1213 arcades")
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack {
                Text("App Version")
                Spacer()
                Text("0.0.4 TestFlight")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Done") {
                
            }
        }
    }
}

struct SettingsItemSwitch: View {
    @State var isOn: Bool = false
    var title: String
    
    var body: some View {
        HStack {
            Toggle(isOn: $isOn) {
                Text(title)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
    }
}
