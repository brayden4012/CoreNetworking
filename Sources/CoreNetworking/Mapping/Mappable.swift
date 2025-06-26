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

public typealias MappableDomainModel = DomainModel & Mappable

internal extension Mappable {
    static var mappingsDict: [String: AnyMapping] {
        mappings.reduce(into: .init()) { partialResult, mapping in
            if let mappableDomainModel = mapping.domainType as? MappableDomainModel.Type {
                partialResult[mappableDomainModel.mappingIdentifier(for: mapping.networkType)] = mapping
            }
        }
    }
}
