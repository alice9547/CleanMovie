//
//  Movie.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation

// MARK: - 도메인 모델 (UI에서 사용)
struct Movie {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let rating: Double
    let runtime: Int?           // 상세 정보에서만 사용
    let genres: [String]        // 상세 정보에서만 사용
    
    // 포스터 URL 생성
    var posterURL: String? {
        guard let posterPath = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    // 평점 문자열 형태로
    var ratingText: String {
        return String(format: "%.1f", rating)
    }
    
    // 개봉일 포맷팅
    var formattedReleaseDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: releaseDate) {
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: date)
        }
        return releaseDate
    }
    
    // 러닝타임 포맷팅
    var formattedRuntime: String? {
        guard let runtime = runtime else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        
        if hours > 0 {
            return "\(hours)시간 \(minutes)분"
        } else {
            return "\(minutes)분"
        }
    }
    
    // 장르 문자열
    var genreText: String {
        return genres.joined(separator: ", ")
    }
}
