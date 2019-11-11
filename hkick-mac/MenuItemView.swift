import Cocoa

extension NSImage.Name {
     static let menuBarIcon = NSImage.Name("MenuBarIcon")
}

class MenuItemView: NSView {
    var score = Score(red: 0, white: 0) {
        didSet {
            self.updateScore()
        }
    }

    private let rootStackView = NSStackView(views: [])
    private let imageView = NSImageView(image: NSImage(named: .menuBarIcon)!)
    private let scoreTextField = NSTextField(frame: .zero)

    init() {
        super.init(frame: .zero)

        self.rootStackView.translatesAutoresizingMaskIntoConstraints = false
        self.rootStackView.orientation = .horizontal
        self.rootStackView.alignment = .centerY
        self.rootStackView.spacing = 3
        self.rootStackView.distribution = .fill
        self.addSubview(self.rootStackView)

        self.scoreTextField.font = NSFont.menuBarFont(ofSize: NSFont.systemFontSize)
        self.scoreTextField.alignment = .center
        self.scoreTextField.isBezeled = false
        self.scoreTextField.drawsBackground = false
        self.scoreTextField.isEditable = false
        self.scoreTextField.isSelectable = false
        self.scoreTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        self.rootStackView.addArrangedSubview(self.imageView)
        self.rootStackView.addArrangedSubview(self.scoreTextField)

        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalToConstant: 15),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1),

            self.rootStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),
            self.rootStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3),
            self.rootStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.rootStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        self.updateScore()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }

    private func updateScore() {
        self.scoreTextField.stringValue = "\(self.score.white):\(self.score.red)"
    }
}
