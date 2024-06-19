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
	
	private lazy var listButtonItem: SpaceKitActionButtonItem = {
		return SpaceKitActionButtonItem(
			title: NSLocalizedString("List Items", comment: ""),
			systemImageName: "list.bullet"
		) { [unowned self] _ in
			self.listButtonAction()
		}
	}()
	
	private lazy var settingsButtonItem: SpaceKitActionButtonItem = {
		return SpaceKitActionButtonItem(
			title: NSLocalizedString("Settings", comment: ""),
			systemImageName: "gearshape.fill"
		) { [unowned self] _ in
			self.settingsButtonAction()
		}
	}()
	
	init(spaceKitViewController: SpaceKitViewController, spaceKitContext: SpaceKit.Context) {
		self.spaceKitViewController = spaceKitViewController
		self.spaceKitContext = spaceKitContext
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	override func loadView() {
		super.loadView()
		
		spaceKitViewController.mapViewControls.add(
			actionButtonItem: listButtonItem,
			in: .secondaryActions,
			at: .top
		)
		
		spaceKitViewController.mapViewControls.add(
			actionButtonItem: settingsButtonItem,
			in: .secondaryActions,
			at: .top
		)
		
		addChild(spaceKitViewController)
		view.addSubview(spaceKitViewController.view)
		spaceKitViewController.didMove(toParent: self)
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
}
