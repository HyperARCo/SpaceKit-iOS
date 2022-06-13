import UIKit
import SpaceKit

class SpaceKitSampleCoordinator {
	private let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let viewController = LoadingViewController()
		navigationController.setViewControllers([viewController], animated: false)
		
		guard let hmdfURL = Bundle.main.urls(forResourcesWithExtension: "zip", subdirectory: "HMDF")?.first else {
			return
		}
		
		let venue = SpaceKitVenue(from: hmdfURL)
		
		SpaceKitContextFactory(venue: venue).make { contextResult in
			switch contextResult {
			case .failure(_):
				return
				
			case .success(let context):
				let spaceKitViewController = SpaceKit.SpaceKitViewControllerFactory(context: context).make()
				let rootViewController = RootViewController(spaceKitViewController: spaceKitViewController, spaceKitContext: context)
				navigationController.setViewControllers([rootViewController], animated: false)
			}
		}
	}
}

class LoadingViewController: UIViewController {
	override func loadView() {
		super.loadView()
		
		view.backgroundColor = .white
		
		let activitySpinner = UIActivityIndicatorView()
		activitySpinner.translatesAutoresizingMaskIntoConstraints = false
		activitySpinner.isHidden = true
		view.addSubview(activitySpinner)
		
		NSLayoutConstraint.activate([
			activitySpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activitySpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak activitySpinner] in
			activitySpinner?.isHidden = false
			activitySpinner?.startAnimating()
		}
	}
}

class RootViewController: UIViewController {
	private let spaceKitViewController: UIViewController
	private let spaceKitContext: SpaceKit.Context
	
	init(spaceKitViewController: UIViewController, spaceKitContext: SpaceKit.Context) {
		self.spaceKitViewController = spaceKitViewController
		self.spaceKitContext = spaceKitContext
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	override func loadView() {
		super.loadView()
		
		addChild(spaceKitViewController)
		view.addSubview(spaceKitViewController.view)
		spaceKitViewController.didMove(toParent: self)
	}
}
