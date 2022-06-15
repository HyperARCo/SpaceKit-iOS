import UIKit

struct ListItem: Hashable {
	let identifier = UUID()
	let name: String
}

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
	
	var listData = [
		ListItem(name: "Apples"),
		ListItem(name: "Bananas"),
	]
	
	var productData = [
		ListItem(name: "Carrots"),
		ListItem(name: "Dates"),
		ListItem(name: "Eggplant")
	]
	
	private lazy var dataSource = ListDataSource(tableView: tableView)
	
	init() {
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
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuse id")
		
		tableView.dataSource = dataSource
		let snapshot = createSnapshot()
		dataSource.apply(snapshot)
	}
	
	private func createSnapshot() -> Snapshot {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections([.list])
		snapshot.appendItems(listData)
		snapshot.appendSections([.products])
		snapshot.appendItems(productData)
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
			let listItem = listData.remove(at: indexPath.row)
			productData.append(listItem)
		case .products:
			let productItem = productData.remove(at: indexPath.row)
			listData.append(productItem)
		}
		
		let snapshot = createSnapshot()
		dataSource.apply(snapshot)
	}
}

class ListDataSource: UITableViewDiffableDataSource<ListViewController.Section, ListViewController.Item> {
	init(tableView: UITableView) {
		super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
			let cell = tableView.dequeueReusableCell(withIdentifier: "reuse id", for: indexPath)
			cell.textLabel?.text = itemIdentifier.name
			return cell
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		ListViewController.Section(rawValue: section)?.headerText
	}
}
