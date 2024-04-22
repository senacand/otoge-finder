//
//  Game.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

enum Game: Equatable {
    case maimaiDx
    case maimaiDxInternational
    case beatmaniaIidx
    case chunithm
    case chunithmInternational
    case danceDanceRevolution
    case danceRushStardom
    case gitadoraDrumMania
    case gitadoraGuitarFreaks
    case projectDiva
    case ongeki
    case polarisChord
    case popNMusic
    case jubeat
    case soundVoltex
    case soundVoltexValkyrie
    case reflecBeat
    case other(name: String)
}

extension Game {
    var name: String {
        switch self {
        case .maimaiDx:
            return "maimai DX"
        case .maimaiDxInternational:
            return "maimai DX (International)"
        case .beatmaniaIidx:
            return "beatmania IIDX"
        case .chunithm:
            return "Chunithm"
        case .chunithmInternational:
            return "Chunithm (International)"
        case .danceDanceRevolution:
            return "DanceDanceRevolution"
        case .danceRushStardom:
            return "DanceRush Stardom"
        case .gitadoraDrumMania:
            return "Gitadora Drum Mania"
        case .gitadoraGuitarFreaks:
            return "Gitadora Guitar Freaks"
        case .projectDiva:
            return "Hatsune Miku Project DIVA"
        case .ongeki:
            return "Ongeki"
        case .polarisChord:
            return "Polaris Chord"
        case .popNMusic:
            return "pop'n music"
        case .jubeat:
            return "Jubeat"
        case .soundVoltex:
            return "Sound Voltex"
        case .soundVoltexValkyrie:
            return "Sound Voltex (Valkyrie)"
        case .reflecBeat:
            return "Reflec Beat"
        case .other(let name):
            return name
        }
    }
    
    var imageString: String? {
        switch self {
        case .maimaiDx, .maimaiDxInternational:
            "maimai"
        case .chunithm, .chunithmInternational:
            "chunithm"
        case .ongeki:
            "ongeki"
        case .projectDiva:
            "project_diva"
        case .soundVoltex, .soundVoltexValkyrie:
            "sdvx"
        case .polarisChord:
            "polarischord"
        case .beatmaniaIidx:
            "iidx"
        case .danceDanceRevolution:
            "ddr"
        case .gitadoraDrumMania, .gitadoraGuitarFreaks:
            "gitadora"
        case .popNMusic:
            "popnmusic"
        case .danceRushStardom:
            "drs"
        case .reflecBeat:
            "reflecbeat"
        case .jubeat:
            "jubeat"
        case .other:
            nil
        }
    }
    
    var priority: Int {
        switch self {
        case .maimaiDx, .maimaiDxInternational:
            0
        case .ongeki:
            1
        case .chunithm, .chunithmInternational:
            2
        case .soundVoltex, .soundVoltexValkyrie:
            3
        case .beatmaniaIidx:
            4
        case .polarisChord:
            5
        case .danceRushStardom:
            6
        case .danceDanceRevolution:
            7
        case .gitadoraDrumMania, .gitadoraGuitarFreaks:
            8
        case .projectDiva:
            9
        case .popNMusic:
            10
        case .reflecBeat:
            11
        case .jubeat:
            12
        case .other:
            13
        }
    }
}

extension Game: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
