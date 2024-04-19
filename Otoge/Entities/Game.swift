//
//  Game.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

enum Game: Equatable {
    case maimaiDx
    case beatmaniaIidx
    case chunithm
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
    case other(name: String)
}

extension Game {
    var name: String {
        switch self {
        case .maimaiDx:
            return "maimai DX"
        case .beatmaniaIidx:
            return "beatmania IIDX"
        case .chunithm:
            return "Chunithm"
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
            return "SoundVoltex"
        case .other(let name):
            return name
        }
    }
}
