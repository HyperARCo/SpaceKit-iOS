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
	
	private var products: [Product] = []
	
	private let locationManager = CLLocationManager()
	
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
		
		let listManager = ListManager(products: products)
		self.listManager = listManager
		
		self.products = products
		
		let venue = SpaceKitVenue(from: hmdfURL)
		
		Task.detached {
			guard let context = try? await SpaceKitContextFactory(venue: venue, isDebugEnabled: true).make() else {
				return
			}
			
			await self.setSpaceKitViewController(context: context)
		}
	}
	
	private func setSpaceKitViewController(context: Context) {
		guard let listManager = listManager else {
			return
		}
		
		let spaceKitViewController = SpaceKit.SpaceKitViewControllerFactory(context: context).make()
		let rootViewController = RootViewController(spaceKitViewController: spaceKitViewController, spaceKitContext: context)
		
		listManager.spaceKitContext = context
		context.listDelegate = listManager
		
		context.requisitesDelegate = self
		context.requestUnfulfilledRequisites(from: Requisite.allCases)
		
		rootViewController.listButtonAction = { [weak self] in
			guard let self = self else { return }
			
			self.listCoordinator = ListCoordinator(
				navigationController: self.navigationController,
				listManager: listManager
			)
			
			self.listCoordinator?.start()
		}
		
		self.navigationController.setViewControllers([rootViewController], animated: false)
	}
}

extension AppCoordinator: SpaceKitRequisitesDelegate {
	func spaceKitContext(_ context: Context, requiresRequisites: [Requisite]) {
		for requisite in requiresRequisites {
			switch requisite {
			case .locationPermission:
				locationManager.requestWhenInUseAuthorization()
			case .preciseLocationPermission:
				break
			case .cameraPermission:
				AVCaptureDevice.requestAccess(for: .video) { _ in }
			@unknown default:
				break
			}
		}
	}
}
