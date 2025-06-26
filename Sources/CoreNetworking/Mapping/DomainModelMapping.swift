//
//  DomainModelMapping.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 6/25/25.
//

import Foundation

public protocol DomainModelMapping {
    associatedtype DomainModelType: DomainModel
    associatedtype NetworkModelType: NetworkModel
    
    func createDomainModel(from networkModel: NetworkModelType) -> DomainModelType
    func createNetworkModel(from domainModel: DomainModelType) -> NetworkModelType
}

extension DomainModelMapping {
    func toAnyMapping() -> AnyMapping {
        AnyMapping(self)
    }
}
