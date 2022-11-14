//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import SpaceKit

class SettingsManager: ObservableObject {

	@Published var elevator: Bool = true {
		didSet { updateOptions() }
	}
	@Published var escalators: Bool = true {
		didSet { updateOptions() }
	}
	@Published var stairs: Bool = true {
		didSet { updateOptions() }
	}

	var spaceKitContext: SpaceKit.Context?

	func updateOptions() {
		var options: Set<TraversalOption> = []

		if stairs {
			options.insert(.stairs)
		}
		if escalators {
			options.insert(.escalator)
		}
		if elevator {
			options.insert(.elevator)
		}

		spaceKitContext?.setTraversalOptions(options)
	}
}
