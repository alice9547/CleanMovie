//
//  MovieSearchResponse.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation

// MARK: - 영화 검색 API 전용 응답
struct MovieSearchResponse: Codable {
    let page: Int
    let results: [MovieSearchItem]
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct MovieSearchItem: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    // Domain Model로 변환
    func toDomain() -> Movie {
        return Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            releaseDate: releaseDate,
            rating: voteAverage,
            runtime: nil,
            genres: []
        )
    }
}
