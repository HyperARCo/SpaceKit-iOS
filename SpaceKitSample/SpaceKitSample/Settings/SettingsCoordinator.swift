//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import SwiftUI
import UIKit

class SettingsCoordinator {
	private let navigationController: UINavigationController
	
	private let settingsManager: SettingsManager
	
	private lazy var settingsHostingController = UIHostingController(rootView: SettingsView(settingsManager: settingsManager))
	
	init(
		navigationController: UINavigationController,
		settingsManager: SettingsManager)
	{
		self.navigationController = navigationController
		self.settingsManager = settingsManager
	}
	
	func start() {
		navigationController.present(settingsHostingController, animated: true)
	}
}
