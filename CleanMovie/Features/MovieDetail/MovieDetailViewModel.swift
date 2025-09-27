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
    let isLoading: Driver<Bool>
    let error: Driver<String?>
    
    private let movieService: MovieNetworkServiceProtocol
    private let disposeBag = DisposeBag()
    private let movieId: Int
    
    init(movieId: Int, movieService: MovieNetworkServiceProtocol) {
        self.movieId = movieId
        self.movieService = movieService
        
        let loadingIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        // startWith(()) 제거 - 명시적 호출만
        let movieDetail = loadTrigger
            .flatMapLatest { [movieService, movieId] _ -> Observable<Movie?> in
                return movieService.getMovieDetail(id: movieId)
                    .trackActivity(loadingIndicator)
                    .trackError(errorTracker)
                    .map { Optional($0) }
                    .catchErrorJustReturn(nil)
            }
        
        self.movie = movieDetail
            .asDriver(onErrorJustReturn: nil)
        
        self.isLoading = loadingIndicator.asDriver()
        
        self.error = errorTracker.asDriver()
            .map { $0?.localizedDescription }
    }
    
    // 명시적 호출 메서드
    func loadMovie() {
        loadTrigger.onNext(())
    }
    
    deinit {
        print("MovieDetailViewModel deinit")
    }
}
