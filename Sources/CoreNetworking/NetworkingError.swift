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
    
    public var errorDescription: String {
        switch self {
        case .urlError(let error):
            error.localizedDescription
        case .decodingError(let error):
            "Internal error: \(decodingErrorDescription(for: error))"
        case .missingMapping(let type):
            "Internal error: Missing mapping for \(type)."
        case .invalidType(let type):
            "Internal error : Invalid type \(type)."
        case .other(let error):
            "Unknown error: \(error.localizedDescription)."
        }
    }
    
    private func decodingErrorDescription(for error: DecodingError) -> String {
        switch error {
        case .typeMismatch(let type, let context):
            "Type mismatch error at \(context.codingPath): Expected to decode \(type), but found \(context.debugDescription)."
        case .valueNotFound(let type, let context):
            "Value not found error at \(context.codingPath): Expected to find \(type), but it was not found."
        case .keyNotFound(let key, let context):
            "Key not found error at \(context.codingPath): Key '\(key.stringValue)' not found."
        case .dataCorrupted(let context):
            "Data corrupted error: \(context.debugDescription)."
        default:
            "Unknown decoding error: \(error.localizedDescription)."
        }
    }
}
