import Futura
import UIKit

extension UIDevice {
    fileprivate static var enableSignals: Void = {
        current.beginGeneratingDeviceOrientationNotifications()
    }()
}

extension SignalProducerAdapter where Subject: UIDevice {
    /// Device orientation signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var orientation: Signal<UIDeviceOrientation> {
        if let signal: Signal<UIDeviceOrientation> = loadCache(for: "orientationChange") {
            return signal
        } else {
            _ = UIDevice.enableSignals
            let emitter: Emitter<UIDeviceOrientation> = .init()
            let closureHolder = ClosureHolder<NSNotification>({
                guard let device = $0?.object as? UIDevice else { return }
                emitter.emit(device.orientation)
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<NSNotification>.invoke),
                             name: UIDevice.orientationDidChangeNotification,
                             object: subject)
            cache(emitter, for: "orientationChange")
            cache(closureHolder, for: "orientationChangeClosure")
            return emitter
        }
    }
}
