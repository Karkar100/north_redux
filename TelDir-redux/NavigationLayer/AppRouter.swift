//
//  AppRouter.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import UIKit
import ReSwift

final class AppRouter {
      private let navigationController: UINavigationController
        
      init(window: UIWindow) {
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        mainStore.subscribe(self) {
            $0.select {
              $0.routingState
            }
        }
    }
  
    func pushViewController(identifier: String = "OneContactVC", animated: Bool) {
        let viewController = UIViewController(nibName: identifier, bundle: nil)
        let newViewControllerType = type(of: viewController)
        if let currentVc = navigationController.topViewController {
            let currentViewControllerType = type(of: currentVc)
            if currentViewControllerType == newViewControllerType {
                return
            }
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func initialViewController(animated: Bool) {
        DispatchQueue.main.async {
            let viewController = ContactListViewController()
            self.navigationController.viewControllers = [viewController]
        }
    }
}

// MARK: - StoreSubscriber
extension AppRouter: StoreSubscriber {
  func newState(state: RoutingState) {
      DispatchQueue.main.async {
          let shouldAnimate = self.navigationController.topViewController != nil
            switch state.navigationState {
            case .initial:
                self.initialViewController(animated: shouldAnimate)
            case .oneContact:
                self.pushViewController(identifier: state.navigationState.rawValue, animated: shouldAnimate)
            }
      }
    }
}
