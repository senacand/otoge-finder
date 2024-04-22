//
//  Arcade+OtogeAppMapping.swift
//  Otoge
//
//  Created by Sen on 2024/4/22.
//

extension Arcade {
    init(arcade: OtogeArcade) {
        self.init(
            name: arcade.storeName,
            alternateName: arcade.alternateStoreName,
            location: Location(
                latitude: arcade.lat,
                longitude: arcade.lng,
                address: arcade.address,
                alternateAddress: arcade.alternateAddress
            ),
            games:
                Array(
                    Set(
                        arcade.cabinets.map {
                            Game(cabinet: $0)
                        }
                    )
                )
            ,
            brand: ArcadeBrand.fromArcadeName(arcade.storeName)
        )
    }
}

private extension Game {
    init(cabinet: OtogeCabinet) {
        switch cabinet.game {
        case "CHUNITHM_NEW":
            self = .chunithm
        case "CHUNITHM_NEW_INTERNATIONAL":
            self = .chunithmInternational
        case "MAIMAI_DX":
            self = .maimaiDx
        case "MAIMAI_DX_INTERNATIONAL":
            self = .maimaiDxInternational
        case "ONGEKI":
            self = .ongeki
        case "BEATMANIA_IIDX", "BEATMANIA_IIDX_LIGHTNING_MODEL":
            self = .beatmaniaIidx
        case "DANCEDANCEREVOLUTION", "DANCEDANCEREVOLUTION_20TH_ANNIVERSARY_MODEL":
            self = .danceDanceRevolution
        case "DANCERUSH_STARDOM":
            self = .danceRushStardom
        case "GITADORA_DRUMMANIA":
            self = .gitadoraDrumMania
        case "GITADORA_GUITARFREAKS":
            self = .gitadoraGuitarFreaks
        case "HATSUNE_MIKU_PROJECT_DIVA_ARCADE":
            self = .projectDiva
        case "JUBEAT":
            self = .jubeat
        case "POP_N_MUSIC":
            self = .popNMusic
        case "SOUND_VOLTEX":
            self = .soundVoltex
        case "SOUND_VOLTEX_VALKYRIE_MODEL":
            self = .soundVoltexValkyrie
        case "POLARIS_CHORD":
            self = .polarisChord
        case "REFLEC_BEAT":
            self = .reflecBeat
        default:
            self = .other(
                name: cabinet
                    .game
                    .replacingOccurrences(of: "_", with: " ")
                    .capitalized
            )
        }
    }
}

private extension ArcadeBrand {
    static func fromArcadeName(_ name: String) -> ArcadeBrand? {
        let name = name.lowercased()
        
        if name.contains("gigo") { return .gigo }
        if name.contains("タイト") { return .taito }
        if name.contains("ゲームパニック") { return .gamePanic }
        if name.contains("レジャーランド") { return .leisureLand }
        if name.contains("ラウンドワン") { return .roundOne }
        if name.contains("ジョイポリス") { return .joypolis }
        if name.contains("aso:viba") { return .asoviba }
        if name.contains("ナムコ") || name.contains("namco") { return .namco }
        if name.contains("timezone") { return .timezone }
        if name.contains("cow play") { return .cowPlayCowMoo }
        
        return nil
    }
}
