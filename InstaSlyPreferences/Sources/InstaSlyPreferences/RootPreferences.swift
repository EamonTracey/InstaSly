import SwiftUI
import NomaePreferences
import InstaSlyPreferencesC

let identifier = "com.eamontracey.instasly"

struct RootPreferences: View {
    @Preference("enabled", identifier: identifier) var enabled = true
    @Preference("confirmDoubleTap", identifier: identifier) var confirmDoubleTap = true
    @Preference("confirmHeartTap", identifier: identifier) var confirmHeartTap = false
    @Preference("confirmFollow", identifier: identifier) var confirmFollow = true
    @Preference("alertStyle", identifier: identifier) var alertStyle = 1
    @Preference("alwaysAlert", identifier: identifier) var alwaysAlert = true
    @Preference("minimumPostAge", identifier: identifier) var minimumPostAge = 604800
    @Preference("postAgeMultiplier", identifier: identifier) var postAgeMultiplier = 1
    
    var body: some View {
        Form {
            Header("InstaSly", icon: (Image(contentsOfFile: "/Library/PreferenceBundles/InstaSlyPreferences.bundle/icon@3x.png") ?? Image(systemName: "eyeglasses")).resizable().frame(width: 50, height: 50), subtitle: "Developed by Eamon Tracey")
            Section(header: Text("Enable/Disable"), footer: Text("Instagram restart required to affectuate changes")) {
                Toggle("Enable", isOn: $enabled)
            }
            if enabled {
                Section(header: Text("Confirmations")) {
                    Toggle("Confirm Double Tap", isOn: $confirmDoubleTap)
                    Toggle("Confirm Heart Tap", isOn: $confirmHeartTap)
                    Toggle("Confirm Follow", isOn: $confirmFollow)
                }
                if confirmDoubleTap || confirmHeartTap || confirmFollow {
                    Section(header: Text("Alert Style")) {
                        Picker("", selection: $alertStyle) {
                            // UIAlertController.Style: 0 -> Action Sheet, 1 -> Alert
                            Text("Alert").tag(1)
                            Text("Action Sheet").tag(0)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                if confirmDoubleTap || confirmHeartTap {
                    Section(header: Text("Post Age"), footer: Text("Alert only when a post is older than the specified time")) {
                        if !alwaysAlert {
                            Picker("", selection: $minimumPostAge) {
                                Text("Day").tag(86400)
                                Text("Week").tag(604800)
                                Text("Month").tag(2419200)
                                Text("Year").tag(31536000)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            Stepper("Number of \(minimumPostAge == 86400 ? "Day" : minimumPostAge == 604800 ? "Week" : minimumPostAge == 2419200 ? "Month" : minimumPostAge == 31536000 ? "Year" : "???")s: \(postAgeMultiplier)", value: $postAgeMultiplier, in: 1...9999)
                        }
                        Toggle("Always Alert", isOn: $alwaysAlert)
                    }
                }
            }
            Section(footer: Text("© Eamon Tracey 2021")) {
                HStack {
                    Image(contentsOfFile: "/Library/PreferenceBundles/InstaSlyPreferences.bundle/instagram@3x.png")
                    Button("Kill Instagram") {
                        let task = NSTask()
                        task.launchPath = "/usr/bin/killall"
                        task.arguments = ["-9", "Instagram"]
                        task.launch()
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                    .foregroundColor(.red)
                }
                HStack {
                    Image(contentsOfFile: "/Library/PreferenceBundles/InstaSlyPreferences.bundle/github@3x.png")
                    Button("Source Code ❤️") {
                        UIApplication.shared.open(URL(string: "https://github.com/EamonTracey/InstaSly")!, options: .init(), completionHandler: .none)
                    }
                }
            }
        }
        .navigationBarTitle("InstaSly")
        .environment(\.horizontalSizeClass, .regular)
    }
}

private extension Image {
    init?(contentsOfFile path: String) {
        guard let uiImage = UIImage(contentsOfFile: path) else { return nil }
        self.init(uiImage: uiImage)
    }
}
