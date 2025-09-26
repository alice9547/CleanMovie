//
//  MainCoordinator.swift
//  CleanArchitecture
//
//  Created by 김은서 on 9/25/25.
//

import Foundation
import UIKit

class MainCoordinator: CoordinatorProtocol {
    private let navigationController: UINavigationController
    private let diContainer: DIContainerProtocol
    
    init(navigationController: UINavigationController, diContainer: DIContainerProtocol) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let movieSearchCoordinator = diContainer.makeMovieSearchCoordinator(navigationController: navigationController)
        movieSearchCoordinator.start()
    }
    
    deinit {
        print("MainCoordinator deinit")
    }
}
