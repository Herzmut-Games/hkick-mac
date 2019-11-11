import CocoaMQTT

class Updater: NSObject, CocoaMQTTDelegate {
    var changeHandler: ((Score) -> ())?

    private var score = Score(red: 0, white: 0) {
        didSet {
            DispatchQueue.main.async {
                self.changeHandler?(self.score)
            }
        }
    }

    private let client = CocoaMQTT(clientID: "hkick-mac", host: "172.30.1.32", port: 1883)

    private static let redScoreTopic = "score/red"
    private static let whiteScoreTopic = "score/white"

    func connect() {
        self.client.delegate = self
        self.client.keepAlive = 60
        self.client.cleanSession = false

        _ = self.client.connect()
    }

    // MARK: - CocoaMQTTDelegate

    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        self.client.subscribe(Updater.redScoreTopic)
        self.client.subscribe(Updater.whiteScoreTopic)
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        if message.topic == Updater.whiteScoreTopic || message.topic == Updater.redScoreTopic {
            if let str = message.string, let score = Int(str) {
                switch message.topic {
                case Updater.redScoreTopic:
                    self.score.red = score
                case Updater.whiteScoreTopic:
                    self.score.white = score
                default:
                    break
                }
            }
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics topics: [String]) {
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        if let error = err {
            NSLog("[Updater] Disconnected: \(error.localizedDescription)")
        }
        NSLog("[Updater] Reconnecting in 10 seconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            NSLog("[Updater] Reconnecting...")
            _ = self.client.connect()
        }
    }
}
