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
    
    private let movieService: MovieNetworkServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(movieService: MovieNetworkServiceProtocol) {
        self.movieService = movieService
        
        let searchResult = searchTrigger
            .withLatestFrom(searchQuery)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .flatMapLatest { [movieService] query -> Observable<[Movie]> in
                return movieService.searchMovies(query: query, page: 1)
                    .catchAndReturn([]) // 에러는 네트워크에서 처리됨
            }
        
        self.movies = searchResult
            .startWith([])
            .asDriver(onErrorJustReturn: [])
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
