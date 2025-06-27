//
//  DomainModel+MappingUtilities.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 6/27/25.
//

import Foundation

public extension DomainModel where Self: Mappable {
    func networkModel<NetworkModelType: NetworkModel>(for type: NetworkModelType.Type) throws -> NetworkModelType {
        guard let mapping = Self.mappingsDict[Self.mappingIdentifier(for: type)] else {
            throw NetworkingError.missingMapping(type)
        }
        guard let networkModel = mapping.createNetworkModel(from: self) as? NetworkModelType else {
            throw NetworkingError.invalidType(type)
        }
        return networkModel
    }
    
    init<NetworkModelType: NetworkModel>(from networkModel: NetworkModelType) throws {
        guard let mapping = Self.mappingsDict[Self.mappingIdentifier(for: NetworkModelType.self)] else {
            throw NetworkingError.missingMapping(type(of: networkModel))
        }
        guard let domainModel = mapping.createDomainModel(from: networkModel) as? Self else {
            throw NetworkingError.invalidType(type(of: networkModel))
        }
        self = domainModel
    }
    
    static func mappingIdentifier(for networkType: NetworkModel.Type) -> String {
        "\(String(describing: self))<->\(String(describing: networkType))"
    }
}
