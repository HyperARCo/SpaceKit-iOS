import UIKit

class LoadingViewController: UIViewController {
	override func loadView() {
		super.loadView()
		
		view.backgroundColor = .white
		
		let activitySpinner = UIActivityIndicatorView()
		activitySpinner.translatesAutoresizingMaskIntoConstraints = false
		activitySpinner.isHidden = true
		view.addSubview(activitySpinner)
		
		NSLayoutConstraint.activate([
			activitySpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activitySpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak activitySpinner] in
			activitySpinner?.isHidden = false
			activitySpinner?.startAnimating()
		}
	}
}
