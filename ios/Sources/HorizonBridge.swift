import Foundation

@_silgen_name("horizon_ios_start")
private func horizon_ios_start() -> Bool

@_silgen_name("horizon_ios_stop")
private func horizon_ios_stop() -> Bool

@_silgen_name("horizon_ios_is_running")
private func horizon_ios_is_running() -> Bool

@_silgen_name("horizon_ios_touch_begin")
private func horizon_ios_touch_begin(_ id: UInt64, _ x: Float, _ y: Float)

@_silgen_name("horizon_ios_touch_move")
private func horizon_ios_touch_move(_ id: UInt64, _ x: Float, _ y: Float)

@_silgen_name("horizon_ios_touch_end")
private func horizon_ios_touch_end(_ id: UInt64, _ x: Float, _ y: Float)

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

    func touchBegan(id: UInt64, x: Float, y: Float) {
        horizon_ios_touch_begin(id, x, y)
    }

    func touchMoved(id: UInt64, x: Float, y: Float) {
        horizon_ios_touch_move(id, x, y)
    }

    func touchEnded(id: UInt64, x: Float, y: Float) {
        horizon_ios_touch_end(id, x, y)
    }
}
