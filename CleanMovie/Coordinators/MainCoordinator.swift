//
//  MainCoordinator.swift
//  CleanArchitecture
//
//  Created by 김은서 on 9/25/25.
//

import Foundation
import UIKit

class MainCoordinator: CoordinatorProtocol {
    private var navigationController: UINavigationController
    private let diContainer: DIContainerProtocol
    
    init(navigationController: UINavigationController, diContainer: DIContainerProtocol) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        showMainScreen()
    }
    
    private func showMainScreen() {
        // TODO: 첫 화면 구현
        // let mainVC = diContainer.makeMainViewController()
        // navigationController.setViewControllers([mainVC], animated: false)
    }
}
