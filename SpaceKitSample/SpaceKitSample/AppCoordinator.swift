//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

import SpaceKit

@MainActor class AppCoordinator {
	private let navigationController: UINavigationController

	private var listManager: ListManager?
	private var listCoordinator: ListCoordinator?

	private var settingsManager: SettingsManager?
	private var settingsCoordinator: SettingsCoordinator?
	
	private let demoAPIKey: String = "_INSERT_API_KEY_HERE_"
	
	private var products: [Product] = []

	private let locationManager = CLLocationManager()
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let viewController = LoadingViewController()
		navigationController.setViewControllers([viewController], animated: false)

		guard
			let productsURL = Bundle.main.url(
				forResource: "sampleProducts",
				withExtension: "json",
				subdirectory: "CustomResources"),
			let productsData = try? Data(contentsOf: productsURL),
			let products = try? JSONDecoder().decode([Product].self, from: productsData) else
		{
			return
		}

		let listManager = ListManager(products: products)
		self.listManager = listManager

		let settingsManager = SettingsManager()
		self.settingsManager = settingsManager

		self.products = products
		
		let organizationIdentifier: String = "_INSERT_ORGANISATION_ID_HERE_"
		let venueIdentifier: String = "_INSERT_VENUE_ID_HERE_"
		
		Task.detached {
			do {
				try await self.loadVenue(in: organizationIdentifier, with: venueIdentifier)
			} catch {
				fatalError(error.localizedDescription)
			}
		}
	}
	
	private nonisolated func loadVenue(in organizationIdentifier: String, with venueIdentifier: String) async throws {
		let managerConfig = VenueManagerConfiguration(
			organizationIdentifier: organizationIdentifier,
			apiKey: demoAPIKey
		)
		
		let venueManager = VenueManagerFactory(configuration: managerConfig).make()
		let venue = try await venueManager.fetchVenue(forVenueWithIdentifier: venueIdentifier)
		
		let configurationURL = Bundle.main.url(forResource: "spacekitconfiguration", withExtension: "json")
		let context = try await SpaceKitContextFactory(
			venue: venue,
			configurationFileURL: configurationURL
		).make()
		
		await setSpaceKitViewController(context: context)
	}

	private func setSpaceKitViewController(context: Context) {
		guard let listManager = listManager, let settingsManager = settingsManager else {
			return
		}
		
		listManager.spaceKitContext = context
		context.listDelegate = listManager
		
		let spaceKitViewController = SpaceKit.SpaceKitViewControllerFactory(context: context).make()
		let rootViewController = RootViewController(spaceKitViewController: spaceKitViewController, spaceKitContext: context)

		settingsManager.spaceKitContext = context
		
		Task {
			await checkPermissions()
		}

		rootViewController.listButtonAction = { [weak self] in
			guard let self = self else { return }

			self.listCoordinator = ListCoordinator(
				navigationController: self.navigationController,
				listManager: listManager
			)

			self.listCoordinator?.start()
		}

		rootViewController.settingsButtonAction = { [weak self] in
			guard let self = self else { return }

			self.settingsCoordinator = SettingsCoordinator(
				navigationController: self.navigationController,
				settingsManager: settingsManager
			)

			self.settingsCoordinator?.start()
		}

		self.navigationController.setViewControllers([rootViewController], animated: false)
	}
}

extension AppCoordinator {
	func checkPermissions() async {
		let outstandingRequisites = await Requisite.requestUnfulfilledRequisites(from: Requisite.allCases)
		for requisite in outstandingRequisites {
			switch requisite {
			case .locationPermission:
				locationManager.requestWhenInUseAuthorization()
			case .cameraPermission:
				AVCaptureDevice.requestAccess(for: .video) { _ in }
			case .preciseLocationPermission:
				break
			@unknown default:
				break
			}
		}
	}
}
