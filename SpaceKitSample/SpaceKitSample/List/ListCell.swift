import UIKit

class ListCell: UITableViewCell {
	static let reuseIdentifier = String(describing: ListCell.self)
	
	private static let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
	private static let plusImage = UIImage(systemName: "plus.circle.fill")
	
	private let accessoryImageView = UIImageView(image: plusImage)
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryView = accessoryImageView
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	func configure(with item: ListItem) {
		textLabel?.text = item.name
		
		switch item.accessoryKind {
		case .checkmark:
			accessoryImageView.image = Self.checkmarkImage
			accessoryImageView.tintColor = .systemBlue
		case .plus:
			accessoryImageView.image = Self.plusImage
			accessoryImageView.tintColor = .systemGreen
		}
	}
}
