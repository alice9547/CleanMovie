//
//  MovieSearchViewModel.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation
import RxSwift
import RxCocoa

class MovieSearchViewModel {
    // Input
    private let searchQuery = BehaviorRelay<String>(value: "")
    private let searchTrigger = PublishSubject<Void>()
    
    // Output
    let movies: Driver<[Movie]>
    let isLoading: Driver<Bool>
    let error: Driver<String?>
    
    private let movieService: MovieNetworkServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(movieService: MovieNetworkServiceProtocol) {
        self.movieService = movieService
        
        let loadingIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let searchResult = searchTrigger
            .withLatestFrom(searchQuery)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .flatMapLatest { [weak movieService] query -> Observable<[Movie]> in
                guard let movieService = movieService else { return Observable.empty() }
                
                return movieService.searchMovies(query: query, page: 1)
                    .trackActivity(loadingIndicator)
                    .trackError(errorTracker)
                    .catchErrorJustReturn([])
            }
        
        self.movies = searchResult
            .startWith([])
            .asDriver(onErrorJustReturn: [])
        
        self.isLoading = loadingIndicator.asDriver()
        
        self.error = errorTracker.asDriver()
            .map { $0?.localizedDescription }
    }
    
    func updateSearchQuery(_ query: String) {
        searchQuery.accept(query)
    }
    
    func search() {
        searchTrigger.onNext(())
    }
    
    deinit {
        print("MovieSearchViewModel deinit")
    }
}
