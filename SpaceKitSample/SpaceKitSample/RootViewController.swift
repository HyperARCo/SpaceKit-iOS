//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import UIKit
import SpaceKit

class RootViewController: UIViewController {
	private let spaceKitViewController: SpaceKitViewController
	private let spaceKitContext: SpaceKit.Context
	
	var listButtonAction: () -> Void = { }
	var settingsButtonAction: () -> Void = { }
	
	private lazy var listButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		let config = UIImage.SymbolConfiguration(pointSize: 32)
		button.setImage(UIImage(systemName: "list.bullet", withConfiguration: config), for: .normal)
		button.tintColor = UIColor.gray
		button.addTarget(self, action: #selector(listButtonTapped), for: .primaryActionTriggered)
		button.backgroundColor = .white
		button.layer.cornerRadius = 16
		button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
		button.layer.shadowColor = UIColor.black.cgColor
		button.layer.shadowOffset = CGSize(width: 0, height: 4)
		button.layer.shadowRadius = 15
		button.layer.shadowOpacity = 0.1
		return button
	}()
	
	private lazy var settingsButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		let config = UIImage.SymbolConfiguration(pointSize: 32)
		button.setImage(UIImage(systemName: "gearshape.fill", withConfiguration: config), for: .normal)
		button.tintColor = UIColor.gray
		button.addTarget(self, action: #selector(settingsButtonTapped), for: .primaryActionTriggered)
		button.backgroundColor = .white
		button.layer.cornerRadius = 16
		button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
		button.layer.shadowColor = UIColor.black.cgColor
		button.layer.shadowOffset = CGSize(width: 0, height: 4)
		button.layer.shadowRadius = 15
		button.layer.shadowOpacity = 0.1
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
		
		NSLayoutConstraint.activate([
			listButton.widthAnchor.constraint(equalToConstant: 32),
			listButton.heightAnchor.constraint(equalTo: listButton.widthAnchor),
		])
		
		NSLayoutConstraint.activate([
			settingsButton.widthAnchor.constraint(equalToConstant: 32),
			settingsButton.heightAnchor.constraint(equalTo: settingsButton.widthAnchor),
		])
		
		let buttonStackView = UIStackView(arrangedSubviews: [settingsButton, listButton])
		buttonStackView.axis = .vertical
		buttonStackView.spacing = 8
		buttonStackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(buttonStackView)
		NSLayoutConstraint.activate([
			buttonStackView.leadingAnchor.constraint(equalTo: spaceKitViewController.contentLayoutGuide.leadingAnchor),
			buttonStackView.bottomAnchor.constraint(equalTo: spaceKitViewController.contentLayoutGuide.bottomAnchor),
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
	
	@objc
	private func settingsButtonTapped() {
		settingsButtonAction()
	}
}
