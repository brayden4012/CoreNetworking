//
//  BasicRESTNetworkingService.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 7/14/24.
//

import Combine
import Foundation

public class BasicRESTNetworkingService: RESTNetworkingService {
    public let host: URL
    public var headers: [String: String?]
    public var persistentQueryItems: [URLQueryItem]?
    
    /// Initializes a BasicRESTNetworkingService
    /// - Parameters:
    ///   - host: The host of the REST service you are consuming
    ///   - headers: Optional dictionary of `HTTPHeaderField` values
    ///   - persistentQueryItems: Optional `[URLQueryItem]` to specify query items that should be sent with every request (such as an API key)
    public init(
        host: URL,
        headers: [String: String?] = [:],
        persistentQueryItems: [URLQueryItem]? = nil
    ) {
        self.host = host
        self.headers = headers
        self.persistentQueryItems = persistentQueryItems
    }
    
    public func get<Request: NetworkRequest, Output: DomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError> {
        try dataTask(
            for: try self.request(
                path: request.path,
                queryItems: request.queryItems,
                httpMethod: "GET",
                body: nil
            ),
            requestType: Request.self
        )
    }
    
    public func post<Request: NetworkInputRequest, Output: DomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError> {
        try dataTask(
            for: try self.request(
                path: request.path,
                queryItems: nil,
                httpMethod: "POST",
                body: try request.input.networkModel(for: Request.InputNetworkModel.self)
            ),
            requestType: Request.self
        )
    }
    
    public func patch<Request: NetworkInputRequest, Output: DomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError> {
        try dataTask(
            for: try self.request(
                path: request.path,
                queryItems: nil,
                httpMethod: "PATCH",
                body: try request.input.networkModel(for: Request.InputNetworkModel.self)
            ),
            requestType: Request.self
        )
    }
    
    public func put<Request: NetworkInputRequest, Output: DomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError> {
        try dataTask(
            for: try self.request(
                path: request.path,
                queryItems: nil,
                httpMethod: "PUT",
                body: try request.input.networkModel(for: Request.InputNetworkModel.self)
            ),
            requestType: Request.self
        )
    }
    
    public func delete<Request: NetworkRequest, Output: DomainModel>(_ request: Request) throws -> AnyPublisher<Output, NetworkingError> {
        try dataTask(
            for: try self.request(
                path: request.path,
                queryItems: nil,
                httpMethod: "DELETE",
                body: nil
            ),
            requestType: Request.self
        )
    }
    
    private func request(
        path: String,
        queryItems: [URLQueryItem]?,
        httpMethod: String,
        body: Encodable?
    ) throws -> URLRequest {
        var urlComps = URLComponents(string: host.absoluteString)
        urlComps?.path = path
        urlComps?.queryItems = (queryItems ?? []) + (persistentQueryItems ?? [])
        guard let url = urlComps?.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if let body {
            try request.httpBody = JSONEncoder().encode(body)
        }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    private func dataTask<Request: NetworkRequest, Output: DomainModel>(
        for request: URLRequest,
        requestType: Request.Type
    ) throws -> AnyPublisher<Output, NetworkingError> {
        URLSession.shared.dataTaskPublisher(
            for: request
        )
        .retry(1)
        .tryMap { element -> Data in
            guard let httpResponse = element.response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            return element.data
        }
        .decode(type: Request.ExpectedResponseType.self, decoder: JSONDecoder())
        .tryCompactMap { networkModel in
            try Output.create(from: networkModel)
        }.mapError { error in
            if let networkingError = error as? NetworkingError {
                return networkingError
            } else if let urlError = error as? URLError {
                return NetworkingError.urlError(urlError)
            } else if let decodingError = error as? DecodingError {
                return NetworkingError.decodingError(decodingError)
            } else {
                return NetworkingError.other(error)
            }
        }
        .eraseToAnyPublisher()
    }
}
