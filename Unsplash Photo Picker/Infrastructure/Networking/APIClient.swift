//
//  APIClient.swift
//  Unsplash Photo Picker
//
//  Created by User on 24.05.25.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private let baseURL: URL = URL(string: "https://api.unsplash.com")!
    private let accessKey = "SPAUIlYOhEQRfjLgzXJOuIf_VVlHW17UecarIrjTOF4"
    
    func request<T: Decodable, E: Decodable & Error>(
        endpoint: String,
        method: HTTPMethod,
        queryParameters: [String: Any]? = nil,
        bodyParameters: Encodable? = nil,
        dateFormat: String? = nil,
        headers: [String: String]? = nil,
        errorType: E.Type = APIDefaultError.self,
        isRefreshing: Bool = false
    ) async throws -> T {
        
        var url = baseURL.appendingPathComponent(endpoint)
        
        if let parameters = queryParameters {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            url = urlComponents?.url ?? url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers ?? [:]
        
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        if let parameters = bodyParameters {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            encoder.dateEncodingStrategy = .formatted(formatter)
            request.httpBody = try? encoder.encode(parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }
    
    enum APIError: Error, LocalizedError {
        case invalidResponse
        case noData
        case decodingError
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse: return "Invalid response from server."
            case .noData: return "No data received."
            case .decodingError: return "Failed to decode the data."
            }
        }
    }
    
    struct APIValidationError: Error, Decodable {
        let detail: [Detail]
        
        struct Detail: Decodable {
            let msg: String
        }
    }
    
    struct APIDefaultError: Error, Decodable {
        let detail: String
    }
    
    
}
