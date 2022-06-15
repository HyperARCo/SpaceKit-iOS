import UIKit
import SpaceKit

class SpaceKitSampleCoordinator {
	private let navigationController: UINavigationController
	
	private var listCoordinator: ListCoordinator?
	
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
				
				rootViewController.listButtonAction = { [weak self] in
					guard let self = self else { return }
					self.listCoordinator = ListCoordinator(navigationController: self.navigationController)
					self.listCoordinator?.start()
				}
				
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
	
	var listButtonAction: () -> Void = { }
	
	private lazy var listButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Shopping List", for: .normal)
		button.addTarget(self, action: #selector(listButtonTapped), for: .primaryActionTriggered)
		button.backgroundColor = .white
		button.setTitleColor(UIColor.systemBlue, for: .normal)
		button.layer.cornerRadius = 10
		button.layer.borderColor = UIColor.gray.cgColor
		button.layer.borderWidth = 1
		button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
		return button
	}()
	
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
		
		view.addSubview(listButton)
		NSLayoutConstraint.activate([
			listButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
			listButton.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
			listButton.heightAnchor.constraint(equalToConstant: 44),
		])
	}
	
	@objc
	private func listButtonTapped() {
		listButtonAction()
	}
}
