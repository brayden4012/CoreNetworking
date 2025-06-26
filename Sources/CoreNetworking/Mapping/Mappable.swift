//
//  Mappable.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 6/25/25.
//

import Foundation

public protocol Mappable {
    static var mappings: [DomainModelMapping] { get }
}

internal extension Mappable {
    static var mappingsDict: [ObjectIdentifier: DomainModelMapping] {
        mappings.reduce(into: .init()) { partialResult, mapping in
            partialResult[ObjectIdentifier(mapping.networkType())] = mapping
        }
    }
}
