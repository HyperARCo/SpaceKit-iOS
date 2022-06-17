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
	
	var listItems = [ListItem]()
	var productItems: [ListItem]
	
	private lazy var dataSource = ListDataSource(tableView: tableView)
	
	init(products: [Product]) {
		self.productItems = products.map { product in
			ListItem(name: product.name, accessory: .plus)
		}
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
		let snapshot = createSnapshot()
		dataSource.apply(snapshot)
	}
	
	private func createSnapshot() -> Snapshot {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections([.list])
		snapshot.appendItems(listItems)
		snapshot.appendSections([.products])
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
			var listItem = listItems.remove(at: indexPath.row)
			listItem.accessory = .plus
			productItems.append(listItem)
		case .products:
			var productItem = productItems.remove(at: indexPath.row)
			productItem.accessory = .checkmark
			listItems.append(productItem)
		}
		
		let snapshot = createSnapshot()
		dataSource.apply(snapshot)
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
