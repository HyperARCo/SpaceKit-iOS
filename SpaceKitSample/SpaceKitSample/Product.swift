//
// Copyright © 2022 Dent Reality. All rights reserved.
//

struct Product: Decodable {
	let itemCode: String
	let name: String
	let icon: String
}

extension Product: Comparable {
	enum CodingKeys: String, CodingKey {
		case itemCode = "item_code"
		case name
		case icon
	}
	
	static func < (lhs: Product, rhs: Product) -> Bool {
		lhs.name < rhs.name
	}
	
	static func == (lhs: Product, rhs: Product) -> Bool {
		lhs.itemCode == rhs.itemCode
	}
}
