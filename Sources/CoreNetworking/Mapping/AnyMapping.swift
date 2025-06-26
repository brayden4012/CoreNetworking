//
//  AnyMapping.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 6/25/25.
//

import Foundation

public class AnyMapping {
    private let _createDomainModel: (Codable) -> Any
    private let _createNetworkModel: (Any) -> Codable

    public let networkType: NetworkModel.Type
    public let domainType: DomainModel.Type

    public init<T: DomainModelMapping>(
        _ mapping: T
    ) {
        self.networkType = T.NetworkModelType.self
        self.domainType = T.DomainModelType.self

        self._createDomainModel = { anyNetworkModel in
            guard let networkModel = anyNetworkModel as? T.NetworkModelType else {
                fatalError("Type mismatch in network model")
            }
            return mapping.createDomainModel(from: networkModel)
        }

        self._createNetworkModel = { anyDomainModel in
            guard let domainModel = anyDomainModel as? T.DomainModelType else {
                fatalError("Type mismatch in domain model")
            }
            return mapping.createNetworkModel(from: domainModel)
        }
    }

    public func createDomainModel(from networkModel: Codable) -> Any {
        _createDomainModel(networkModel)
    }

    public func createNetworkModel(from domainModel: Any) -> Codable {
        _createNetworkModel(domainModel)
    }
}
