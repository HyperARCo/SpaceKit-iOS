//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import UIKit

class ListCoordinator {
	private let navigationController: UINavigationController
	
	private let products: [Product]
	
	init(
		navigationController: UINavigationController,
		products: [Product])
	{
		self.navigationController = navigationController
		self.products = products
	}
	
	func start() {
		let listViewController = ListViewController(products: products)
		let listNavigationController = UINavigationController(rootViewController: listViewController)
		navigationController.present(listNavigationController, animated: true)
	}
}
