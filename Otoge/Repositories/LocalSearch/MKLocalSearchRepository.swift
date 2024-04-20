//
//  MKLocalSearchRepository.swift
//  Otoge
//
//  Created by Sen on 2024/4/21.
//

import Foundation
import MapKit

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
    
    func searchLocationWithQuery(_ query1: String, query2: String) async -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = [query1, query2].joined(separator: " ")
        request.resultTypes = .pointOfInterest
        
        let result = try? await MKLocalSearch(request: request)
            .start()
        
        guard result?.mapItems.isEmpty ?? true else {
            return result?.mapItems ?? []
        }
        
        request.naturalLanguageQuery = query1
        
        let addressResult = try? await MKLocalSearch(request: request)
            .start()
        
        return addressResult?.mapItems ?? []
    }
}

extension MKLocalSearchRepository: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onCompleterUpdateResults?(completer.results)
    }
}
