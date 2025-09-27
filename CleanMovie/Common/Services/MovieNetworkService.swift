//
//  MovieNetworkService.swift
//  CleanMovie
//
//  Created by 김은서 on 9/25/25.
//

import Foundation
import Moya
import RxMoya
import RxSwift

// MARK: - Protocol
protocol MovieNetworkServiceProtocol: AnyObject {
    func searchMovies(query: String, page: Int) -> Observable<[Movie]>
    func getMovieDetail(id: Int) -> Observable<Movie>
}

// MARK: - Implementation
class MovieNetworkService: MovieNetworkServiceProtocol {
    private let provider = MoyaProvider<MovieAPI>()
    
    func searchMovies(query: String, page: Int) -> Observable<[Movie]> {
        return performRequest(
            request: provider.rx.request(.searchMovies(query: query, page: page))
                .filterSuccessfulStatusCodes()
                .map(MovieSearchResponse.self)
                .map { response in
                    response.results.map { $0.toDomain() }
                }
                .asObservable()
        )
    }
    
    func getMovieDetail(id: Int) -> Observable<Movie> {
        return performRequest(
            request: provider.rx.request(.movieDetail(id: id))
                .filterSuccessfulStatusCodes()
                .map(MovieDetailResponse.self)
                .map { $0.toDomain() }
                .asObservable()
        )
    }
    
    // 네트워크 요청에 로딩/에러 처리를 자동으로 추가하는 헬퍼 메서드
    private func performRequest<T>(request: Observable<T>) -> Observable<T> {
        return Observable.create { observer in
            // 요청 시작 시 로딩 표시
            LoadingManager.shared.show()
            
            let subscription = request
                .subscribe(
                    onNext: { result in
                        // 성공 시 로딩 숨김
                        LoadingManager.shared.hide()
                        observer.onNext(result)
                    },
                    onError: { error in
                        // 에러 시 로딩 숨김 및 토스트 표시
                        LoadingManager.shared.hide()
                        self.handleError(error)
                        observer.onError(error)
                    },
                    onCompleted: {
                        observer.onCompleted()
                    }
                )
            
            return subscription
        }
    }
    
    private func handleError(_ error: Error) {
        let message: String
        
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                message = "서버 오류가 발생했습니다. (코드: \(response.statusCode))"
            case .underlying(let error, _):
                message = "네트워크 연결을 확인해주세요."
            default:
                message = "요청을 처리할 수 없습니다."
            }
        } else {
            message = error.localizedDescription
        }
        
        ToastManager.shared.show(message: message)
    }
}
