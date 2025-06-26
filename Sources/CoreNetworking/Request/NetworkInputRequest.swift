//
//  InputRequest.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 7/14/24.
//

import Foundation

public protocol NetworkInputRequest: NetworkRequest {
    associatedtype InputNetworkModel: NetworkModel
    associatedtype InputDomainModel: MappableDomainModel
    var input: InputDomainModel { get }
}
