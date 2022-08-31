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
		
		let destinations = destinations(for: listItems)
		spaceKitContext?.setDestinations(destinations)
	}
	
	func addProduct(at index: Int) {
		let productItem = productItems.remove(at: index)
		updateListView?()

		let newListItems = listItems + [productItem]
		let destinations = destinations(for: newListItems)
		spaceKitContext?.setDestinations(destinations)
	}
	
	private func destinations(for identifiers: [String]) -> [SpaceKit.Destination] {
		identifiers.compactMap { identifier in
			guard let product = product(with: identifier) else { return nil }
			return Destination(identifier: identifier, displayName: product.name, icon: UIImage(named: product.icon))
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
	func spaceKitContext(_ context: Context, didUpdateOrderedDestinations orderedDestinations: [Destination]) {
		self.listItems = orderedDestinations.map(\.identifier)
		updateProductItems()
		updateListView?()
	}
}
