//
//  MovieServiceError.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation

enum MovieServiceError: Error, LocalizedError {
    case networkError(String)
    case serverError(Int)
    case invalidQuery
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        case .serverError(let code):
            return "서버 오류 (\(code))"
        case .invalidQuery:
            return "검색어를 입력해주세요"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다"
        }
    }
}
