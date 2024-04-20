//
//  LocalSearchRepository.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import Foundation
import MapKit

protocol LocalSearchRepositoryProtocol {
    var completerResults: AsyncStream<[MKLocalSearchCompletion]> { get }  // TODO: Abstractize MKLocalSearchCompletion
    
    func autocompleteWithSearchQuery(_ query: String)
    func searchLocationWithQuery(_ query1: String, query2: String) async -> [MKMapItem]  // TODO: Abstractize MKMapItem
}
