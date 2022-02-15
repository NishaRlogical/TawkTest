//
//  GithubAPI.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 14/02/22.
//

import Foundation

/// The protocol used to define the specifications necessary for a `GithubAPI`.
public protocol Networking {
    /// The host, conforming to RFC 1808.
    var host: String { get }

    /// The path, conforming to RFC 1808
    var path: String { get }

    /// API Endpoint
    var endpoint: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }

    /// The HTTP request parameters.
    var parameters: [String: Any]? { get }

    /// A dictionary containing all the HTTP header fields
    var headers: [String: String]? { get }
}

/// HTTP Methods
public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case patch = "PATCH"
}

/// GithubAPI Errors
enum NetworkingError: Error {
    case badURL
}

extension Networking {
    /// The URL of the receiver.
    fileprivate var url: String {
        return host + path + endpoint
    }

    public func request<T: Codable>(type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(.failure(NetworkingError.badURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completionHandler(.failure(error))
                return
            }
        }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { data, _, error -> Void in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            if let data = data {
                do {
                    completionHandler(.success(try Store.instance.decoder.decode(type, from: data)))
                } catch {
                    completionHandler(.failure(error))
                    return
                }
            }
        })

        dataTask.resume()
    }
}
