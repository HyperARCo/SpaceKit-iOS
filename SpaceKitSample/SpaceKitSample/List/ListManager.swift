//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import SpaceKit

class ListManager {
	private let products: [Product]
	
	var listItems = [String]()
	var productItems = [String]()
	
	var updateListView: (() -> ())?
	
	var spaceKitContext: SpaceKit.Context?
	
	init(products: [Product]) {
		self.products = products
		updateProductItems()
	}
	
	func product(with identifer: String) -> Product? {
		products.first(where: { $0.itemCode == identifer })
	}
	
	func removeListItem(at index: Int) {
		listItems.remove(at: index)
		updateListView?()
		updateProductItems()
		
		let destinations = destinations(for: listItems)
		spaceKitContext?.setDestinations(destinations)
	}
	
	func addProduct(at index: Int) {
		let productItem = productItems.remove(at: index)
		listItems.append(productItem)
		updateListView?()

		let destinations = destinations(for: listItems)
		spaceKitContext?.setDestinations(destinations)
	}
	
	private func destinations(for identifiers: [String]) -> [SpaceKitDestination] {
		identifiers.compactMap { identifier in
			guard let product = product(with: identifier) else { return nil }
			let icon: UIImage? = if let icon = product.icon { UIImage(named: icon) } else { nil }
			return SpaceKitDestination(identifier: identifier, displayName: product.name, icon: icon)
		}
	}
	
	private func updateProductItems() {
		self.productItems = products
			.filter { product in
				!listItems.contains(product.itemCode)
			}
			.sorted()
			.map(\.itemCode)
	}
}

extension ListManager: SpaceKit.SpaceKitListDelegate {
	func spaceKitContext(
		_ context: any Context,
		didUpdateOrderedDestinations orderedDestinations: [SpaceKitDestination],
		withLevelTransitions levelTransitions: [[LevelTransition]],
		failures: [RoutingFailure]
	) {
		let unorderedItems = failures.compactMap {
			if case .couldNotRouteToDestination(let identifier) = $0 {
				return identifier
			}
			return nil
		}
		
		self.listItems = orderedDestinations.map(\.identifier) + unorderedItems
		updateProductItems()
		updateListView?()
	}
}
