import Cocoa

extension NSImage.Name {
    static let menuBarIcon = NSImage.Name("MenuBarIcon")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let updater = Updater()
    private let whiteItem = NSMenuItem()
    private let redItem = NSMenuItem()

    private var score = Score(red: 0, white: 0) {
        didSet {
            self.updateScore()
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.statusItem.button!.image = NSImage(named: .menuBarIcon)
        self.statusItem.button!.imageHugsTitle = true
        self.statusItem.button!.imagePosition = .imageLeft
        self.statusItem.button!.imageScaling = .scaleProportionallyDown

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
        self.whiteItem.title = "White:\t\(self.score.white)"
        self.redItem.title = "Red:\t\(self.score.red)"

        self.statusItem.button!.attributedTitle = NSAttributedString(
            string: "\(self.score.white):\(self.score.red)",
            attributes: [NSAttributedString.Key.baselineOffset: -1/NSScreen.main!.backingScaleFactor,
                         NSAttributedString.Key.paragraphStyle: {
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.firstLineHeadIndent = 2/NSScreen.main!.backingScaleFactor
                            return paragraphStyle
                         }()])
    }
}
