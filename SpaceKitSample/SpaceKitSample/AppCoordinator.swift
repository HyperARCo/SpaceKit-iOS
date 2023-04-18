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

	private var products: [Product] = []

	private let locationManager = CLLocationManager()
	private let locationDelegate = LocationDelegate()

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
			let products = try? JSONDecoder().decode([Product].self, from: productsData),
			let hmdfURL = Bundle.main.urls(forResourcesWithExtension: "zip", subdirectory: "HMDF")?.first else
		{
			return
		}

		let listManager = ListManager(products: products)
		self.listManager = listManager

		let settingsManager = SettingsManager()
		self.settingsManager = settingsManager

		self.products = products

		let venue = SpaceKitVenue(from: hmdfURL)
		let configuration = Bundle.main.url(forResource: "spacekitconfiguration", withExtension: "json")

		Task.detached {
			do {
				let context = try await SpaceKitContextFactory(
					venue: venue,
					configurationFileURL: configuration).make()
				await self.setSpaceKitViewController(context: context)
			} catch {
				fatalError(error.localizedDescription)
			}

		}
	}

	private func setSpaceKitViewController(context: Context) {
		guard let listManager = listManager, let settingsManager = settingsManager else {
			return
		}
		
		listManager.spaceKitContext = context
		context.listDelegate = listManager
		context.locationDelegate = locationDelegate
		
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
				locationManager.requestAlwaysAuthorization()
			case .cameraPermission:
				await AVCaptureDevice.requestAccess(for: .video) { _ in }
			case .backgroundLocationPermission, .preciseLocationPermission:
				break
			@unknown default:
				break
			}
		}
	}
}

private final class LocationDelegate: SpaceKitLocationDelegate {
	func spaceKitContextShouldAllowBackgroundLocationUpdates(_ context: Context) -> Bool {
		true
	}
}
