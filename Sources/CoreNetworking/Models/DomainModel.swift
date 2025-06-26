//
//  DomainModel.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 7/14/24.
//

import Foundation

public protocol DomainModel: Mappable { }

extension DomainModel {
    func networkModel<NetworkModelType: NetworkModel>(for type: NetworkModelType.Type) throws -> NetworkModelType {
        guard let mapping = Self.mappingsDict[Self.mappingIdentifier(for: type)] else {
            throw NetworkingError.missingMapping(type)
        }
        guard let networkModel = mapping.createNetworkModel(from: self) as? NetworkModelType else {
            throw NetworkingError.invalidType(type)
        }
        return networkModel
    }
    
    static func create<NetworkModelType: NetworkModel>(from networkModel: NetworkModelType) throws -> Self {
        guard let mapping = Self.mappingsDict[Self.mappingIdentifier(for: NetworkModelType.self)] else {
            throw NetworkingError.missingMapping(type(of: networkModel))
        }
        guard let domainModel = mapping.createDomainModel(from: networkModel) as? Self else {
            throw NetworkingError.invalidType(type(of: networkModel))
        }
        return domainModel
    }
    
    static func mappingIdentifier(for networkType: NetworkModel.Type) -> String {
        "\(String(describing: self))<->\(String(describing: networkType))"
    }
}
