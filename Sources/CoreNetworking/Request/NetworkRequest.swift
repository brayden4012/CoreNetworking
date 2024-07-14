//
//  Request.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 7/14/24.
//

import Foundation

public protocol NetworkRequest {
    associatedtype ResponseNetworkModel: Decodable
    associatedtype ResponseDomainModel: DomainModel
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

public extension NetworkRequest {
    var queryItems: [URLQueryItem]? {
        nil
    }
}
