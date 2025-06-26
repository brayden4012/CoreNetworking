//
//  RESTNetworkingService.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 7/14/24.
//

import Combine
import Foundation

public protocol RESTNetworkingService {
    var host: URL { get }
    var headers: [String: String?] { get set }
    func get<Request: NetworkRequest, Output: MappableDomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError>
    func post<Request: NetworkInputRequest, Output: MappableDomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError>
    func patch<Request: NetworkInputRequest, Output: MappableDomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError>
    func put<Request: NetworkInputRequest, Output: MappableDomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError>
    func delete<Request: NetworkRequest, Output: MappableDomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError>
}
