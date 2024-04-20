//
//  LocalSearchRepository.swift
//  Otoge
//
//  Created by Sen on 2024/4/20.
//

import Foundation
import MapKit

protocol LocalSearchRepositoryProtocol {
    var completerResults: AsyncStream<[MKLocalSearchCompletion]> { get }
    func autocompleteWithSearchQuery(_ query: String)
    func searchLocationWithQuery(_ query: String) async -> [MKMapItem]
}

final class MKLocalSearchRepository: NSObject, LocalSearchRepositoryProtocol {
    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.resultTypes = .pointOfInterest
        completer.delegate = self
        
        return completer
    }()
    private var onCompleterUpdateResults: (([MKLocalSearchCompletion]) -> Void)?
    
    private(set) lazy var completerResults: AsyncStream<[MKLocalSearchCompletion]> = {
        AsyncStream { [weak self] continuation in
            self?.onCompleterUpdateResults = { results in
                continuation.yield(results)
            }
        }
    }()
    
    func autocompleteWithSearchQuery(_ query: String) {
        localSearchCompleter.queryFragment = query
    }
    
    func searchLocationWithQuery(_ query: String) async -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        let result = try? await MKLocalSearch(request: request)
            .start()
        
        return result?.mapItems ?? []
    }
}

extension MKLocalSearchRepository: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onCompleterUpdateResults?(completer.results)
    }
}
