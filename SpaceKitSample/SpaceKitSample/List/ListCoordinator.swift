//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import UIKit

class ListCoordinator {
	private let navigationController: UINavigationController
	
	private let listManager: ListManager
	
	init(
		navigationController: UINavigationController,
		listManager: ListManager)
	{
		self.navigationController = navigationController
		self.listManager = listManager
	}
	
	func start() {
		let listViewController = ListViewController(listManager: listManager)
		let listNavigationController = UINavigationController(rootViewController: listViewController)
		
		listManager.updateListView = { [weak listViewController] in
			listViewController?.updateList()
		}
		
		navigationController.present(listNavigationController, animated: true)
	}
}
