//
//  Publisher+.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import Foundation
import Combine

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }
    
    func resolveServerError(with appState: inout Store<AppState>) -> AnyPublisher<Output, Error> {
        tryCatch { [weak appState] error -> AnyPublisher<Output, Error> in
            return Fail<Output, Error>(error: error).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }
}

public extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestData(httpCodes: HTTPCodes = .success) -> AnyPublisher<Data, Error> {
        return tryMap {
            assert(!Thread.isMainThread)
            guard let response = ($0.1 as? HTTPURLResponse) else {
                throw APIError.unexpectedResponse
            }
            guard httpCodes.contains(response.statusCode) else {
                if let description = try? JSONDecoder().decode(Response<String>.self, from: $0.0) {
                    throw APIError.httpCodeWithResponse(response.statusCode, description)
                }
                throw APIError.httpCode(response.statusCode)
            }
            return $0.0
        }
        .extractUnderlyingError()
        .eraseToAnyPublisher()
    }

    func requestDataWithStatusCode(httpCodes: HTTPCodes = .success) -> AnyPublisher<(Data, Int), Error> {
        return tryMap {
            assert(!Thread.isMainThread)
            guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                throw APIError.unexpectedResponse
            }
            guard httpCodes.contains(code) else {
                throw APIError.httpCode(code) // code 값을 밖으로 이어가져가도록 설정
            }
            return ($0.0, code)
        }
        .extractUnderlyingError()
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
        return requestData(httpCodes: httpCodes)
            .tryMap {
                if let data = try? JSONDecoder().decode(Value.self, from: $0){
                    return data
                } else {
                    throw APIError.decode
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestJSONWithStatusCode<Value>(httpCodes: HTTPCodes) -> AnyPublisher<(Value, Int), Error> where Value: Decodable {
        return requestDataWithStatusCode(httpCodes: httpCodes)
            .tryMap {
                if let data = try? JSONDecoder().decode(Value.self, from: $0.0) {
                    return (data, $0.1)
                } else {
                    throw APIError.decode
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}



extension Publisher where Output: ResponseProtocol {
    func unwrapResponseToVO() -> AnyPublisher<Output.DTO.VO, Error> {
        tryMap {
            guard let documents = $0.documents else { throw APIError.dataIsNull }
            return documents.toDomain()
        }
        .eraseToAnyPublisher()
    }
}
