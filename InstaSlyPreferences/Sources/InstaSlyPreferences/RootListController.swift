import SwiftUI
import InstaSlyPreferencesC

class RootListController: IOListController {
    
    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "Root", target: self)
                setValue(specifiers, forKey: "_specifiers")
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = HeaderView(name: "InstaSly", developer: "Eamon Tracey", image: Image(contentsOfFile: bundle.path(forResource: "icon@3x", ofType: "png")!))
        let headerUIView = UIHostingController(rootView: headerView).view!
        headerUIView.bounds = .init(x: 0, y: -25, width: 0, height: 100)
        if let tableView = value(forKey: "_table") as? UITableView {
            tableView.tableHeaderView = headerUIView
            tableView.tableHeaderView?.backgroundColor = .clear
        }
    }
    
    @objc func killInstagram() {
        let task = NSTask()
        task.launchPath = "/usr/bin/killall"
        task.arguments = ["-9", "Instagram"]
        task.launch()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    @objc func openGithub() {
        UIApplication.shared.open(URL(string: "https://github.com/EamonTracey/InstaSly")!, options: .init(), completionHandler: .none)
    }
    
}

private extension Image {
    init(contentsOfFile path: String) {
        let uiImage = UIImage(contentsOfFile: path)!
        self.init(uiImage: uiImage)
    }
}
