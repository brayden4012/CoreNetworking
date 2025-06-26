//
//  Mappable.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 6/25/25.
//

import Foundation

public protocol Mappable {
    static var mappings: [AnyMapping] { get }
}

internal extension Mappable {
    static var mappingsDict: [String: AnyMapping] {
        mappings.reduce(into: .init()) { partialResult, mapping in
            partialResult[mapping.domainType.mappingIdentifier(for: mapping.networkType)] = mapping
        }
    }
}
