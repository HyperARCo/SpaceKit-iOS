//
// Copyright © 2022 Dent Reality. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

	@ObservedObject var settingsManager: SettingsManager

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Routing")) {
					Toggle("Stairs", isOn: $settingsManager.stairs)
					Toggle("Escalators", isOn: $settingsManager.escalators)
					Toggle("Elevators", isOn: $settingsManager.elevator)
				}
			}
			.navigationBarTitle("Settings")
		}
	}
}
