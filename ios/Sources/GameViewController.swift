import MetalKit
import UIKit

final class GameViewController: UIViewController {
    private let statusLabel = UILabel()
    private var gameView: MTKView!

    override func loadView() {
        gameView = MTKView(frame: .zero, device: MTLCreateSystemDefaultDevice())
        gameView.backgroundColor = .black
        gameView.isPaused = true
        gameView.enableSetNeedsDisplay = false
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "Horizon iOS\nRust host is ready"
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if HorizonBridge.shared.start() {
            statusLabel.text = "Horizon iOS\nRust host started\nMetal surface ready"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        HorizonBridge.shared.stop()
        super.viewWillDisappear(animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { forward(touch, phase: .began) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { forward(touch, phase: .moved) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { forward(touch, phase: .ended) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { forward(touch, phase: .cancelled) }
    }

    private enum TouchPhase { case began, moved, ended, cancelled }

    private func forward(_ touch: UITouch, phase: TouchPhase) {
        let point = touch.location(in: view)
        let scale = view.window?.screen.nativeScale ?? 1
        let x = Float(point.x * scale)
        let y = Float(point.y * scale)
        let id = UInt64(bitPattern: Int64(ObjectIdentifier(touch).hashValue))
        switch phase {
        case .began: HorizonBridge.shared.touchBegan(id: id, x: x, y: y)
        case .moved: HorizonBridge.shared.touchMoved(id: id, x: x, y: y)
        case .ended, .cancelled: HorizonBridge.shared.touchEnded(id: id, x: x, y: y)
        }
    }
}
