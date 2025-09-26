//
//  MovieCoordinator.swift
//  CleanMovie
//
//  Created by 김은서 on 9/26/25.
//

import Foundation
import UIKit

class MovieDetailCoordinator: CoordinatorProtocol {
    private let navigationController: UINavigationController
    private let diContainer: DIContainerProtocol
    
    init(navigationController: UINavigationController, diContainer: DIContainerProtocol) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        // 기본 시작은 구현하지 않음
    }
    
    func startWithMovieId(_ movieId: Int) {
        let detailViewController = diContainer.makeMovieDetailViewController(movieId: movieId)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    deinit {
        print("MovieDetailCoordinator deinit")
    }
}
