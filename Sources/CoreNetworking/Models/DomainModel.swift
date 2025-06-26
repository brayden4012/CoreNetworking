//
//  DomainModel.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 7/14/24.
//

import Foundation

public protocol DomainModel: Mappable { }

public extension DomainModel {
    func networkModel<NetworkModelType: NetworkModel>(for type: NetworkModelType.Type) throws -> NetworkModelType {
        guard let mapping = Self.mappingsDict[ObjectIdentifier(type)] else {
            throw NetworkingError.missingMapping(type)
        }
        return mapping.toNetworkModel()
    }
    
    static func create<NetworkModelType: NetworkModel>(from networkModel: NetworkModelType) throws -> Self {
        guard let mapping = Self.mappingsDict[ObjectIdentifier(NetworkModelType.self)] else {
            throw NetworkingError.missingMapping(type(of: networkModel))
        }
        return mapping.create(from: networkModel)
    }
}
