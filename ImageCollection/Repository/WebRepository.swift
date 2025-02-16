//
//  WebRepository.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import Foundation
import Combine

import Foundation
import Combine

enum ApiModel { }

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error> where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            showLog(from: request)
            return session
                .dataTaskPublisher(for: request)
                .requestJSON(httpCodes: httpCodes)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
    
    /// 캐시 사용 Call
    func callCache<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error> where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            showLog(from: request)

            // 캐시 확인
            if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
                print("✅ Using Cached Data")
                return Just(cachedResponse.data)
                    .decode(type: Value.self, decoder: JSONDecoder())
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }

            // 네트워크 요청
            return session
                .dataTaskPublisher(for: request)
                .tryMap { output -> (data: Data, response: URLResponse) in
                    guard let httpResponse = output.response as? HTTPURLResponse,
                          httpCodes.contains(httpResponse.statusCode) else {
                        throw URLError(.badServerResponse)
                    }

                    // 캐시 저장
                    let cachedResponse = CachedURLResponse(response: output.response, data: output.data)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                    return (output.data, httpResponse)
                }
                .requestJSON(httpCodes: httpCodes)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }

}

// MARK: - private
private extension WebRepository {
    func showLog(from request: URLRequest) {
        let headers = request.allHTTPHeaderFields
        let body = request.httpBody
        let method = request.httpMethod ?? "NONE METHOD"
        let baseURL = findBasePathURL(from: request.url) ?? "NONE URL"
        let queryItems = findQueryItems(from: request.url) ?? []
        let sortedQueryItems = queryItems.sorted(by: { $0.name < $1.name })
        var queryInfo = ""
        
        if sortedQueryItems.isEmpty == false {
            queryInfo += "?"
            sortedQueryItems.forEach {
                queryInfo += "\($0.name)=\($0.value ?? "")&"
            }
            _ = queryInfo.popLast()
        }
        
        print("\n< \(method) > \(baseURL)\(queryInfo)")
        
        // MARK: 헤더 정보
        if let headers = headers {
            let sortedHeaders = headers.sorted(by: { $0.key < $1.key })
            print("  [ Headers ]")
            for header in sortedHeaders {
                print("    \(header.key): \(header.value)")
            }
        }
        // MARK: post body 정보
        if let body = body,
            let bodyDictionary = try? JSONSerialization.jsonObject(with: body, options: []) as? [String: Any] {
            let sortedBodyDictionary = bodyDictionary.sorted(by: { $0.key < $1.key })
            print("  [ Body ]")
            for (key, value) in sortedBodyDictionary {
                print("    \(key): \(value)")
            }
        }
    }
    
    func findQueryItems(from url: URL?) -> [URLQueryItem]? {
        guard let url = url else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
    }
    
    func findBasePathURL(from url: URL?) -> String? {
        guard let url = url else { return nil }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.query = nil
        components?.fragment = nil
        return components?.url?.absoluteString
    }
}

// MARK: - APICall
protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: Any]? { get }
    func body() throws -> Data?
}

public enum APIError: LocalizedError {
    case urlGenerate
    case decode
    case unexpectedResponse
    case httpCode(HTTPCode)
    case httpCodeWithResponse(HTTPCode, Response<String>)
    case dataIsNull
    case customError(code: Int, message: String, subMessege: String)
    
    public var errorDescription: String? {
        switch self {
        case .urlGenerate:
            return "URL 생성과정에 문제가 발생했습니다."
        case .decode:
            return "Decode 과정에 문제가 발생했습니다."
        case .unexpectedResponse:
            return "알 수 없는 문제가 발생했습니다."
        case let .httpCode(code):
            if code == 204 {
                return "컨텐츠가 존재하지 않습니다: \(code)"
            }
            return "알 수 없는 코드입니다: \(code)"
        case let .httpCodeWithResponse(code, response):
            return response.toDescription(with: code)
        case .dataIsNull:
            return "데이터가 존재하지 않습니다.(NULL)"
        case .customError(let code, let message, let subMessege):
            return "code: \(code)\nmessage: \(message)\nsubMessage: \(subMessege)"
        }
    }
}

extension APICall {
    func urlRequest(baseURL: String) throws -> URLRequest {
        
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            throw APIError.urlGenerate
        }
        var urlQueryItems = [URLQueryItem]()
        
        if let queryParameters = queryParameters {
            queryParameters.forEach {
                urlQueryItems.append(.init(name: $0.key, value: "\($0.value)"))
            }
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else {
            throw APIError.urlGenerate
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        request.cachePolicy = .returnCacheDataElseLoad
        return request
    }
}

public typealias HTTPCode = Int
public typealias HTTPCodes = Range<HTTPCode>

public extension HTTPCodes {
    static let success = 200 ..< 300
}
