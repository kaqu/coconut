import Futura
import UIKit


extension SignalProducerAdapter where Subject: UIApplication {
    /// Application didFinishLaunching signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var didFinishLaunching: Signal<Void> {
        if let signal: Signal<Void> = loadCache(for: "didFinishLaunching") {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIApplication>({ _ in
                emitter.emit()
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<UIApplication>.invoke),
                             name: UIApplication.didFinishLaunchingNotification,
                             object: subject)
            cache(emitter, for: "didFinishLaunching")
            cache(closureHolder, for: "didFinishLaunchingClosure")
            return emitter
        }
    }
    
    /// Application willEnterForeground signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var willEnterForeground: Signal<Void> {
        if let signal: Signal<Void> = loadCache(for: "willEnterForeground") {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIApplication>({ _ in
                emitter.emit()
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<UIApplication>.invoke),
                             name: UIApplication.willEnterForegroundNotification,
                             object: subject)
            cache(emitter, for: "willEnterForeground")
            cache(closureHolder, for: "willEnterForegroundClosure")
            return emitter
        }
    }
    
    /// Application didBecomeActive signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var didBecomeActive: Signal<Void> {
        if let signal: Signal<Void> = loadCache(for: "didBecomeActive") {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIApplication>({ _ in
                emitter.emit()
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<UIApplication>.invoke),
                             name: UIApplication.didBecomeActiveNotification,
                             object: subject)
            cache(emitter, for: "didBecomeActive")
            cache(closureHolder, for: "didBecomeActiveClosure")
            return emitter
        }
    }
    
    /// Application willResignActive signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var willResignActive: Signal<Void> {
        if let signal: Signal<Void> = loadCache(for: "willResignActive") {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIApplication>({ _ in
                emitter.emit()
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<UIApplication>.invoke),
                             name: UIApplication.willResignActiveNotification,
                             object: subject)
            cache(emitter, for: "willResignActive")
            cache(closureHolder, for: "willResignActiveClosure")
            return emitter
        }
    }
    
    /// Application didEnterBackground signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var didEnterBackground: Signal<Void> {
        if let signal: Signal<Void> = loadCache(for: "didEnterBackground") {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIApplication>({ _ in
                emitter.emit()
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<UIApplication>.invoke),
                             name: UIApplication.didEnterBackgroundNotification,
                             object: subject)
            cache(emitter, for: "didEnterBackground")
            cache(closureHolder, for: "didEnterBackgroundClosure")
            return emitter
        }
    }
    
    /// Application willTerminate signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var willTerminate: Signal<Void> {
        if let signal: Signal<Void> = loadCache(for: "willTerminate") {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIApplication>({ _ in
                emitter.emit()
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<UIApplication>.invoke),
                             name: UIApplication.willTerminateNotification,
                             object: subject)
            cache(emitter, for: "willTerminate")
            cache(closureHolder, for: "willTerminateClosure")
            return emitter
        }
    }
    
    /// Application didReceiveMemoryWarning signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var didReceiveMemoryWarning: Signal<Void> {
        if let signal: Signal<Void> = loadCache(for: "didReceiveMemoryWarning") {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIApplication>({ _ in
                emitter.emit()
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<UIApplication>.invoke),
                             name: UIApplication.didReceiveMemoryWarningNotification,
                             object: subject)
            cache(emitter, for: "didReceiveMemoryWarning")
            cache(closureHolder, for: "didReceiveMemoryWarningClosure")
            return emitter
        }
    }
}
