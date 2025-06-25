//
//  DomainModel.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 7/14/24.
//

import Foundation

public protocol DomainModel {
    associatedtype NetworkModel: Decodable
    init?(from networkModel: NetworkModel) throws
}
