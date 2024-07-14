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
    public var accessToken: String?
    
    init(host: URL, accessToken: String? = nil) {
        self.host = host
        self.accessToken = accessToken
    }
    
    public func get<Request: NetworkRequest>(_ request: Request) throws -> AnyPublisher<Request.ResponseDomainModel, Error> {
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
    
    public func post<Request: NetworkInputRequest>(_ request: Request) throws -> AnyPublisher<Request.ResponseDomainModel, Error> {
        try dataTask(
            for: try self.request(
                path: request.path,
                queryItems: nil,
                httpMethod: "POST",
                body: request.body
            ),
            requestType: Request.self
        )
    }
    
    public func patch<Request: NetworkInputRequest>(_ request: Request) throws -> AnyPublisher<Request.ResponseDomainModel, Error> {
        try dataTask(
            for: try self.request(
                path: request.path,
                queryItems: nil,
                httpMethod: "PATCH",
                body: request.body
            ),
            requestType: Request.self
        )
    }
    
    public func put<Request: NetworkInputRequest>(_ request: Request) throws -> AnyPublisher<Request.ResponseDomainModel, Error> {
        try dataTask(
            for: try self.request(
                path: request.path,
                queryItems: nil,
                httpMethod: "PUT",
                body: request.body
            ),
            requestType: Request.self
        )
    }
    
    public func delete<Request: NetworkRequest>(
        _ request: Request
    ) throws -> AnyPublisher<Request.ResponseDomainModel, Error> {
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
        var request = URLRequest(
            url: host
                .appending(path: path)
                .appending(queryItems: queryItems ?? [])
        )
        request.httpMethod = httpMethod
        if let body {
            try request.httpBody = JSONEncoder().encode(body)
        }
        if let accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func dataTask<Request: NetworkRequest>(
        for request: URLRequest,
        requestType: Request.Type
    ) throws -> AnyPublisher<Request.ResponseDomainModel, Error> {
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
        .decode(type: Request.ResponseNetworkModel.self, decoder: JSONDecoder())
        .tryCompactMap { networkModel in
            try Request.ResponseDomainModel(from: networkModel)
        }
        .eraseToAnyPublisher()
    }
}