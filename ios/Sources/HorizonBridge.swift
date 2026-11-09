import Foundation

@_silgen_name("horizon_ios_start")
private func horizon_ios_start() -> Bool

@_silgen_name("horizon_ios_stop")
private func horizon_ios_stop() -> Bool

@_silgen_name("horizon_ios_is_running")
private func horizon_ios_is_running() -> Bool

final class HorizonBridge {
    static let shared = HorizonBridge()

    private init() {}

    @discardableResult
    func start() -> Bool {
        horizon_ios_start()
    }

    @discardableResult
    func stop() -> Bool {
        horizon_ios_stop()
    }

    var isRunning: Bool {
        horizon_ios_is_running()
    }
}
