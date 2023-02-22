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
      let navigationController: UINavigationController
        
      init(window: UIWindow) {
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        mainStore.subscribe(self) {
            $0.select {
              $0.routingState
            }
        }
    }
  
    private func pushViewController(identifier: String, animated: Bool) {
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
    
    private func initialViewController(identifier: String, animated: Bool) {
        let viewController = ContactListViewController()
        navigationController.pushViewController(viewController, animated: animated)
    }
}

// MARK: - StoreSubscriber
extension AppRouter: StoreSubscriber {
  func newState(state: RoutingState) {
    let shouldAnimate = navigationController.topViewController != nil
      switch state.navigationState {
      case .initial:
          initialViewController(identifier: state.navigationState.rawValue, animated: shouldAnimate)
      case .oneContact:
          pushViewController(identifier: state.navigationState.rawValue, animated: shouldAnimate)
      }
  }
}
