//
//  NetworkRequest.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 7/14/24.
//

import Foundation

public protocol NetworkRequest {
    associatedtype ExpectedResponseType: NetworkModel
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

public extension NetworkRequest {
    var queryItems: [URLQueryItem]? {
        nil
    }
}
