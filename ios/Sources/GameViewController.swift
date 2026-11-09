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
}
