import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let updater = Updater()
    private let whiteItem = NSMenuItem()
    private let redItem = NSMenuItem()
    private let menuItemView = MenuItemView()

    private var score = Score(red: 0, white: 0) {
        didSet {
            self.updateScore()
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.menuItemView.translatesAutoresizingMaskIntoConstraints = false
        self.statusItem.button!.addSubview(self.menuItemView)

        NSLayoutConstraint.activate([
            self.menuItemView.leadingAnchor.constraint(equalTo: self.statusItem.button!.leadingAnchor),
            self.menuItemView.trailingAnchor.constraint(equalTo: self.statusItem.button!.trailingAnchor),
            self.menuItemView.topAnchor.constraint(equalTo: self.statusItem.button!.topAnchor),
            self.menuItemView.bottomAnchor.constraint(equalTo: self.statusItem.button!.bottomAnchor),
        ])

        let quitItem = NSMenuItem()
        quitItem.title = "Quit HKick"
        quitItem.action = #selector(self.didSelectQuit)

        let menu = NSMenu(title: "HKick")
        self.statusItem.menu = menu
        menu.addItem(self.whiteItem)
        menu.addItem(self.redItem)
        menu.addItem(.separator())
        menu.addItem(quitItem)

        self.updater.changeHandler = { score in
            DispatchQueue.main.async {
                self.score = score
            }
        }
        self.updater.connect()

        self.updateScore()
    }

    @objc private func didSelectQuit() {
        NSApplication.shared.terminate(self)
    }

    private func updateScore() {
        self.menuItemView.score = self.score
        self.whiteItem.title = "White:\t\(self.score.white)"
        self.redItem.title = "Red:\t\(self.score.red)"
    }
}
