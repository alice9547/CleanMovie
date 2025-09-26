//
//  MovieSearchCoordinator.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation
import UIKit

class MovieSearchCoordinator: CoordinatorProtocol {
    private let navigationController: UINavigationController
    private let diContainer: DIContainerProtocol
    
    init(navigationController: UINavigationController, diContainer: DIContainerProtocol) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let searchViewController = diContainer.makeMovieSearchViewController()
        
        // 메모리 누수 방지: [weak self]
        searchViewController.onMovieSelected = { [weak self] movieId in
            self?.showMovieDetail(movieId: movieId)
        }
        
        navigationController.setViewControllers([searchViewController], animated: false)
    }
    
    private func showMovieDetail(movieId: Int) {
        let detailCoordinator = MovieDetailCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        detailCoordinator.startWithMovieId(movieId)
    }
    
    deinit {
        print("MovieSearchCoordinator deinit")
    }
}
