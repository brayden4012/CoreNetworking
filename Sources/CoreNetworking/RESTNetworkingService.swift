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
    func get<Request: NetworkRequest>(_ request: Request) throws -> AnyPublisher<Request.ExpectedResponseType, NetworkingError>
    func post<Request: NetworkInputRequest>(_ request: Request) throws -> AnyPublisher<Request.ExpectedResponseType, NetworkingError>
    func patch<Request: NetworkInputRequest>(_ request: Request) throws -> AnyPublisher<Request.ExpectedResponseType, NetworkingError>
    func put<Request: NetworkInputRequest>(_ request: Request) throws -> AnyPublisher<Request.ExpectedResponseType, NetworkingError>
    func delete<Request: NetworkRequest>(_ request: Request) throws -> AnyPublisher<Request.ExpectedResponseType, NetworkingError>
}
