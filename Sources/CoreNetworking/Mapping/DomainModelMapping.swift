//
//  DomainModelMapping.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 6/25/25.
//

import Foundation

public protocol DomainModelMappingV2 {
    associatedtype DomainModelType: DomainModel
    associatedtype NetworkModelType: NetworkModel
    
    func createDomainModel(from networkModel: NetworkModelType) -> DomainModelType
    func createNetworkModel(from domainModel: DomainModelType) -> NetworkModelType
}

extension DomainModelMappingV2 {
    func toAnyMapping() -> AnyMapping {
        AnyMapping(self)
    }
}
