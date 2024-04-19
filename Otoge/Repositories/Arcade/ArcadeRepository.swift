//
//  ArcadeRepository.swift
//  Otoge
//
//  Created by Sen on 2024/4/19.
//

protocol ArcadeRepositoryProtocol {
    func getArcadesByPosition(latitude: Double, longitude: Double) async -> [Arcade]
}
