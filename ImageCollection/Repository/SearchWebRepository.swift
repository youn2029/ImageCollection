//
//  SearchWebRepository.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import Foundation
import Combine

protocol SearchWebRepository: WebRepository {
    func imageSearchList(param: SearchRequest) -> AnyPublisher<[SearchVO], Error>
    func vClipSearchList(param: SearchRequest) -> AnyPublisher<[SearchVO], Error>
}

struct RealSearchWebRepository: SearchWebRepository {
    let session: URLSession
    let baseURL: String

    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = "https://dapi.kakao.com/v2/search"
    }
    
    func imageSearchList(param: SearchRequest) -> AnyPublisher<[SearchVO], Error> {
        let dao: AnyPublisher<Response<[ImageDTO]>, Error>
        dao = callCache(endpoint: API.imageSearchList(param: param))
        return dao.unwrapResponseToVO()
    }
    
    
    func vClipSearchList(param: SearchRequest) -> AnyPublisher<[SearchVO], Error> {
        let dao: AnyPublisher<Response<[VClipDTO]>, Error>
        dao = callCache(endpoint: API.vClipSearchList(param: param))
        return dao.unwrapResponseToVO()
    }
}

// MARK: - Endpoints

extension RealSearchWebRepository {
    enum API {
        case imageSearchList(param: SearchRequest)
        case vClipSearchList(param: SearchRequest)
    }
}

extension RealSearchWebRepository.API: APICall {
    var path: String {
        switch self {
        case .imageSearchList(_):
            return "/image"
        case .vClipSearchList(_):
            return "/vclip"
        }
    }
    var method: String {
        switch self {
        case .imageSearchList(_), .vClipSearchList(_):
            return "get"
        }
    }
    var headers: [String: String]? {
        return [
            "Content-Type":"application/json",
            "Accept" : "application/json",
            "Authorization" : "KakaoAK 3ce13dc22158c602f344eb7ce924985d"
        ]
    }
    func body() throws -> Data? {
        return nil
    }
    var queryParameters: [String : Any]? {
        switch self {
        case let .imageSearchList(param), let .vClipSearchList(param):
            return param.toDictionary
        }
    }
}
