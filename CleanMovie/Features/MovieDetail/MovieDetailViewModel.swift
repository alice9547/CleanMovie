//
//  MovieDetailViewModel.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel {
    // Input
    private let loadTrigger = PublishSubject<Void>()
    
    // Output
    let movie: Driver<Movie?>
    
    private let movieService: MovieNetworkServiceProtocol
    private let disposeBag = DisposeBag()
    private let movieId: Int
    
    init(movieId: Int, movieService: MovieNetworkServiceProtocol) {
        self.movieId = movieId
        self.movieService = movieService
        
        // 로딩/에러 처리는 네트워크 레이어에서 자동 처리
        let movieDetail = loadTrigger
            .flatMapLatest { [movieService, movieId] _ -> Observable<Movie?> in
                return movieService.getMovieDetail(id: movieId)
                    .map { Optional($0) }
                    .catchAndReturn(nil)
            }
        
        self.movie = movieDetail
            .asDriver(onErrorJustReturn: nil)
    }
    
    func loadMovie() {
        loadTrigger.onNext(())
    }
    
    deinit {
        print("MovieDetailViewModel deinit")
    }
}
