//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import UIKit

class ListCoordinator {
	private let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let listViewController = ListViewController()
		let listNavigationController = UINavigationController(rootViewController: listViewController)
		navigationController.present(listNavigationController, animated: true)
	}
}
