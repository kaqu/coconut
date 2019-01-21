import Futura
import UIKit

extension UIViewController {
    fileprivate static var swizzle: Void = {
        swizzleInstance(method: #selector(UIViewController.viewDidLoad),
                        with: #selector(UIViewController.swizzle_viewDidLoad),
                        for: UIViewController.self)
        swizzleInstance(method: #selector(UIViewController.viewWillAppear(_:)),
                        with: #selector(UIViewController.swizzle_viewWillAppear(_:)),
                        for: UIViewController.self)
        swizzleInstance(method: #selector(UIViewController.viewDidAppear(_:)),
                        with: #selector(UIViewController.swizzle_viewDidAppear(_:)),
                        for: UIViewController.self)
        swizzleInstance(method: #selector(UIViewController.viewWillDisappear(_:)),
                        with: #selector(UIViewController.swizzle_viewWillDisappear(_:)),
                        for: UIViewController.self)
        swizzleInstance(method: #selector(UIViewController.viewDidDisappear(_:)),
                        with: #selector(UIViewController.swizzle_viewDidDisappear(_:)),
                        for: UIViewController.self)
    }()

    @objc fileprivate func swizzle_viewDidLoad() {
        self.swizzle_viewDidLoad()
        self.signalOut.viewDidLoadEmitter.emit()
    }

    @objc fileprivate func swizzle_viewWillAppear(_ animated: Bool) {
        self.swizzle_viewWillAppear(animated)
        self.signalOut.viewWillAppearEmitter.emit()
    }

    @objc fileprivate func swizzle_viewDidAppear(_ animated: Bool) {
        self.swizzle_viewDidAppear(animated)
        self.signalOut.viewDidAppearEmitter.emit()
    }

    @objc fileprivate func swizzle_viewWillDisappear(_ animated: Bool) {
        self.swizzle_viewWillDisappear(animated)
        self.signalOut.viewWillDisappearEmitter.emit()
    }

    @objc fileprivate func swizzle_viewDidDisappear(_ animated: Bool) {
        self.swizzle_viewDidDisappear(animated)
        self.signalOut.viewDidDisappearEmitter.emit()
    }
}

extension SignalProducerAdapter where Subject: UIViewController {
    fileprivate var viewDidLoadEmitter: Emitter<Void> {
        if let signal: Emitter<Void> = loadCache(for: "viewDidLoad") {
            return signal
        } else {
            _ = UIViewController.swizzle
            let emitter: Emitter<Void> = .init()
            cache(emitter, for: "viewDidLoad")
            return emitter
        }
    }

    /// viewDidLoad signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var viewDidLoad: Signal<Void> {
        return viewDidLoadEmitter
    }
}

extension SignalProducerAdapter where Subject: UIViewController {
    fileprivate var viewWillAppearEmitter: Emitter<Void> {
        if let signal: Emitter<Void> = loadCache(for: "viewWillAppear") {
            return signal
        } else {
            _ = UIViewController.swizzle
            let emitter: Emitter<Void> = .init()
            cache(emitter, for: "viewWillAppear")
            return emitter
        }
    }

    /// viewWillAppear signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var viewWillAppear: Signal<Void> {
        return viewWillAppearEmitter
    }
}

extension SignalProducerAdapter where Subject: UIViewController {
    fileprivate var viewDidAppearEmitter: Emitter<Void> {
        if let signal: Emitter<Void> = loadCache(for: "viewDidAppear") {
            return signal
        } else {
            _ = UIViewController.swizzle
            let emitter: Emitter<Void> = .init()
            cache(emitter, for: "viewDidAppear")
            return emitter
        }
    }

    /// viewDidAppear signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var viewDidAppear: Signal<Void> {
        return viewDidAppearEmitter
    }
}

extension SignalProducerAdapter where Subject: UIViewController {
    fileprivate var viewWillDisappearEmitter: Emitter<Void> {
        if let signal: Emitter<Void> = loadCache(for: "viewWillDisappear") {
            return signal
        } else {
            _ = UIViewController.swizzle
            let emitter: Emitter<Void> = .init()
            cache(emitter, for: "viewWillDisappear")
            return emitter
        }
    }

    /// viewWillDisappear signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var viewWillDisappear: Signal<Void> {
        return viewWillDisappearEmitter
    }
}

extension SignalProducerAdapter where Subject: UIViewController {
    fileprivate var viewDidDisappearEmitter: Emitter<Void> {
        if let signal: Emitter<Void> = loadCache(for: "viewDidDisappear") {
            return signal
        } else {
            _ = UIViewController.swizzle
            let emitter: Emitter<Void> = .init()
            cache(emitter, for: "viewDidDisappear")
            return emitter
        }
    }

    /// viewDidDisappear signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var viewDidDisappear: Signal<Void> {
        return viewDidDisappearEmitter
    }
}
