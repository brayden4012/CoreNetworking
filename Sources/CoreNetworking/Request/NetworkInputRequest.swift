//
//  InputRequest.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 7/14/24.
//

import Foundation

public protocol NetworkInputRequest: NetworkRequest {
    associatedtype NetworkModel: Encodable
    var body: NetworkModel { get }
}
