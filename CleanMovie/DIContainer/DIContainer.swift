//
//  DIContainer.swift
//  CleanArchitecture
//
//  Created by 김은서 on 9/25/25.
//

import Foundation
import UIKit

protocol DIContainerProtocol {
    // Common Services
    func makeMovieNetworkService() -> MovieNetworkServiceProtocol
    
    // MovieSearch Feature
    func makeMovieSearchCoordinator(navigationController: UINavigationController) -> MovieSearchCoordinator
    func makeMovieSearchViewController() -> MovieSearchViewController
    func makeMovieSearchViewModel() -> MovieSearchViewModel
    
    // MovieDetail Feature
    func makeMovieDetailCoordinator(navigationController: UINavigationController) -> MovieDetailCoordinator
    func makeMovieDetailViewController(movieId: Int) -> MovieDetailViewController
    func makeMovieDetailViewModel(movieId: Int) -> MovieDetailViewModel
}

class DIContainer: DIContainerProtocol {
    
    // MARK: - Common Services
    func makeMovieNetworkService() -> MovieNetworkServiceProtocol {
        return MovieNetworkService()
    }
    
    // MARK: - MovieSearch Feature
    func makeMovieSearchCoordinator(navigationController: UINavigationController) -> MovieSearchCoordinator {
        return MovieSearchCoordinator(navigationController: navigationController, diContainer: self)
    }
    
    func makeMovieSearchViewController() -> MovieSearchViewController {
        let viewController = MovieSearchViewController()
        let viewModel = makeMovieSearchViewModel()
        viewController.configure(with: viewModel)
        return viewController
    }
    
    func makeMovieSearchViewModel() -> MovieSearchViewModel {
        let networkService = makeMovieNetworkService()
        return MovieSearchViewModel(movieService: networkService)
    }
    
    // MARK: - MovieDetail Feature
    func makeMovieDetailCoordinator(navigationController: UINavigationController) -> MovieDetailCoordinator {
        return MovieDetailCoordinator(navigationController: navigationController, diContainer: self)
    }
    
    func makeMovieDetailViewController(movieId: Int) -> MovieDetailViewController {
        let viewController = MovieDetailViewController()
        let viewModel = makeMovieDetailViewModel(movieId: movieId)
        viewController.configure(with: viewModel)
        return viewController
    }
    
    func makeMovieDetailViewModel(movieId: Int) -> MovieDetailViewModel {
        let networkService = makeMovieNetworkService()
        return MovieDetailViewModel(movieId: movieId, movieService: networkService)
    }
}
