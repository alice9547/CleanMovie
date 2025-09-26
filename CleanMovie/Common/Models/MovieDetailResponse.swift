//
//  MovieDetailResponse.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation

/// MARK: - 영화 상세 API 전용 응답
struct MovieDetailResponse: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let runtime: Int?
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres
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
            runtime: runtime,
            genres: genres.map { $0.name }
        )
    }
    
    struct Genre: Codable {
        let id: Int
        let name: String
    }
}
