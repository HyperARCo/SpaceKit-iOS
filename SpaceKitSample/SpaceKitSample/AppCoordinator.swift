//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import UIKit
import SpaceKit

class AppCoordinator {
	private let navigationController: UINavigationController
	
	private var listCoordinator: ListCoordinator?
	
	private var products: [Product] = []
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let viewController = LoadingViewController()
		navigationController.setViewControllers([viewController], animated: false)
		
		guard
			let productsURL = Bundle.main.url(forResource: "sampleProducts", withExtension: "json", subdirectory: "CustomResources"),
			let productsData = try? Data(contentsOf: productsURL),
			let products = try? JSONDecoder().decode([Product].self, from: productsData),
			let hmdfURL = Bundle.main.urls(forResourcesWithExtension: "zip", subdirectory: "HMDF")?.first else
		{
			return
		}
		
		self.products = products
		
		let venue = SpaceKitVenue(from: hmdfURL)
		
		SpaceKitContextFactory(venue: venue).make { contextResult in
			switch contextResult {
			case .failure(_):
				return
				
			case .success(let context):
				let spaceKitViewController = SpaceKit.SpaceKitViewControllerFactory(context: context).make()
				let rootViewController = RootViewController(spaceKitViewController: spaceKitViewController, spaceKitContext: context)
				
				rootViewController.listButtonAction = { [weak self] in
					guard let self = self else { return }
					
					self.listCoordinator = ListCoordinator(
						navigationController: self.navigationController,
						products: products
					)
					
					self.listCoordinator?.start()
				}
				
				navigationController.setViewControllers([rootViewController], animated: false)
			}
		}
	}
}
