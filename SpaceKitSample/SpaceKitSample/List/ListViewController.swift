//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
	enum Section: Int {
		case list
		case products
		
		var headerText: String {
			switch self {
			case .list: return "Shopping List"
			case .products: return "Products"
			}
		}
	}
	
	typealias Item = ListItem
	typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
	
	private lazy var dataSource = ListDataSource(tableView: tableView)
	
	private let listManager: ListManager
	
	init(listManager: ListManager) {
		self.listManager = listManager
		super.init(style: .grouped)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	override func loadView() {
		super.loadView()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .close,
			target: self,
			action: #selector(closeButtonTapped)
		)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
		
		tableView.dataSource = dataSource
		updateList()
	}
	
	func updateList() {
		let snapshot = createSnapshot()
		dataSource.apply(snapshot)
	}
	
	private func createSnapshot() -> Snapshot {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections([.list])
		let listItems: [ListItem] = listManager.listItems.compactMap { identifier in
			guard let product = listManager.product(with: identifier) else { return nil }
			return ListItem(identifier: identifier, name: product.name, iconName: product.icon, accessory: .checkmark)
		}
		snapshot.appendItems(listItems)
		snapshot.appendSections([.products])
		let productItems: [ListItem] = listManager.productItems.compactMap { identifier in
			guard let product = listManager.product(with: identifier) else { return nil }
			return ListItem(identifier: identifier, name: product.name, iconName: product.icon, accessory: .plus)
		}
		snapshot.appendItems(productItems)
		return snapshot
	}
	
	@objc
	private func closeButtonTapped() {
		dismiss(animated: true)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let section = Section(rawValue: indexPath.section) else { return }
		
		switch section {
		case .list:
			listManager.removeListItem(at: indexPath.row)
		case .products:
			listManager.addProduct(at: indexPath.row)
		}
	}
}

class ListDataSource: UITableViewDiffableDataSource<ListViewController.Section, ListViewController.Item> {
	init(tableView: UITableView) {
		super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
			guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell else {
				return UITableViewCell()
			}
			
			cell.configure(with: itemIdentifier)
			return cell
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		ListViewController.Section(rawValue: section)?.headerText
	}
}
