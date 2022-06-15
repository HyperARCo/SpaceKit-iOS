import UIKit

struct ListItem: Hashable {
	enum AccessoryKind {
		case plus, checkmark
	}
	
	let identifier = UUID()
	let name: String
	var accessoryKind: AccessoryKind
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
	
	var listData = ["Apples", "Bananas"].map { ListItem(name: $0, accessoryKind: .checkmark) }
	var productData = ["Carrots", "Dates", "Eggplant"].map { ListItem(name: $0, accessoryKind: .plus)}
	
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
		
		tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
		
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
			var listItem = listData.remove(at: indexPath.row)
			listItem.accessoryKind = .plus
			productData.append(listItem)
		case .products:
			var productItem = productData.remove(at: indexPath.row)
			productItem.accessoryKind = .checkmark
			listData.append(productItem)
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
