//
//  DomainModelMapping.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 6/25/25.
//

import Foundation

public class DomainModelMapping: Hashable {
    func networkType() -> NetworkModel.Type {
        fatalError("Must override in subclass")
    }
    func create<DomainModelType: DomainModel, NetworkModelType: NetworkModel>(from networkModel: NetworkModelType) -> DomainModelType {
        fatalError("Must override in subclass")
    }
    func toNetworkModel<NetworkModelType: NetworkModel>() -> NetworkModelType {
        fatalError("Must override in subclass")
    }
}

public extension DomainModelMapping {
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: networkType()))
    }
    
    static func == (lhs: DomainModelMapping, rhs: DomainModelMapping) -> Bool {
        lhs === rhs
    }
}
