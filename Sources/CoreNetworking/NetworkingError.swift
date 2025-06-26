//
//  NetworkingError.swift
//  CoreNetworking
//
//  Created by Brayden Harris on 6/25/25.
//

import Foundation

public enum NetworkingError: Error {
    case urlError(URLError)
    case decodingError(DecodingError)
    case missingMapping(NetworkModel.Type)
    case invalidType(NetworkModel.Type)
    case other(Error)
}
