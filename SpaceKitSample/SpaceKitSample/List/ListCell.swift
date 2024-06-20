//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import UIKit

struct ListItem: Hashable {
	enum Accessory {
		case plus, checkmark
		
		static let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
		static let plusImage = UIImage(systemName: "plus.circle.fill")
		
		var image: UIImage? {
			switch self {
			case .plus:
				return Self.plusImage
			case .checkmark:
				return Self.checkmarkImage
			}
		}
		
		var tintColor: UIColor {
			switch self {
			case .plus:
				return .systemGreen
			case .checkmark:
				return .systemBlue
			}
		}
	}
	
	let identifier: String
	let name: String
	let iconName: String?
	var accessory: Accessory
}

class ListCell: UITableViewCell {
	static let reuseIdentifier = String(describing: ListCell.self)
	
	private let accessoryImageView = UIImageView(image: ListItem.Accessory.plusImage)
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryView = accessoryImageView
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	func configure(with item: ListItem) {
		textLabel?.text = item.name
		if let iconName = item.iconName {
			imageView?.image = UIImage(named: iconName)
		} else {
			imageView?.image = nil
		}
		accessoryImageView.image = item.accessory.image
		accessoryImageView.tintColor = item.accessory.tintColor
	}
}
