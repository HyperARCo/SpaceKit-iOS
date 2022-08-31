//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import UIKit
import SpaceKit

class RootViewController: UIViewController {
	private let spaceKitViewController: SpaceKitViewController
	private let spaceKitContext: SpaceKit.Context
	
	var listButtonAction: () -> Void = { }
	
	private lazy var listButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		let config = UIImage.SymbolConfiguration(pointSize: 32)
		button.setImage(UIImage(systemName: "list.bullet", withConfiguration: config), for: .normal)
		button.addTarget(self, action: #selector(listButtonTapped), for: .primaryActionTriggered)
		button.backgroundColor = .white
		button.layer.cornerRadius = 10
		button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
		return button
	}()
	 
	init(spaceKitViewController: SpaceKitViewController, spaceKitContext: SpaceKit.Context) {
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
			listButton.leadingAnchor.constraint(equalTo: spaceKitViewController.contentLayoutGuide.leadingAnchor),
			listButton.bottomAnchor.constraint(equalTo: spaceKitViewController.contentLayoutGuide.bottomAnchor),
			
			listButton.widthAnchor.constraint(equalToConstant: 44),
			listButton.heightAnchor.constraint(equalTo: listButton.widthAnchor),
		])
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	@objc
	private func listButtonTapped() {
		listButtonAction()
	}
}
