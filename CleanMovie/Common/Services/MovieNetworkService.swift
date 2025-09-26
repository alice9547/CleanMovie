//
//  MovieNetworkService.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
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
        return provider.rx
            .request(.searchMovies(query: query, page: page))
            .filterSuccessfulStatusCodes()
            .map(MovieSearchResponse.self)
            .map { response in
                response.results.map { $0.toDomain() }
            }
            .asObservable()
            .catchError { error in
                print("Search error: \(error)")
                return Observable.just([])
            }
    }
    
    func getMovieDetail(id: Int) -> Observable<Movie> {
        return provider.rx
            .request(.movieDetail(id: id))
            .filterSuccessfulStatusCodes()
            .map(MovieDetailResponse.self)
            .map { $0.toDomain() }
            .asObservable()
            .catchError { error in
                print("Detail error: \(error)")
                return Observable.empty()
            }
    }
}
