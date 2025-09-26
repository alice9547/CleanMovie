//
//  MovieAPI.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation
import Moya

enum MovieAPI {
    case searchMovies(query: String, page: Int = 1)
    case movieDetail(id: Int)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .searchMovies:
            return "/search/movie"
        case .movieDetail(let id):
            return "/movie/\(id)"
        }
    }
    
    var method: Moya.Method { .get }
    
    var task: Task {
        let apiKey = "d9f7d0bd6033b7b8c5ff19d6e5c5e7e5"
        
        switch self {
        case .searchMovies(let query, let page):
            return .requestParameters(
                parameters: [
                    "api_key": apiKey,
                    "query": query,
                    "page": page,
                    "language": "ko-KR"
                ],
                encoding: URLEncoding.queryString
            )
        case .movieDetail:
            return .requestParameters(
                parameters: [
                    "api_key": apiKey,
                    "language": "ko-KR"
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
