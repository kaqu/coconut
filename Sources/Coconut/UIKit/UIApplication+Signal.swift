import Futura
import UIKit


extension SignalProducerAdapter where Subject: UIApplication {
    /// Application didFinishLaunching signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var didFinishLaunching: Signal<Void> {
        if let signal = bindingCache[cacheKey("didFinishLaunching")] as? Signal<Void> {
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
            bindingCache[cacheKey("didFinishLaunching")] = emitter
            bindingCache[cacheKey("didFinishLaunchingClosure")] = closureHolder
            return emitter
        }
    }
    
    /// Application willEnterForeground signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var willEnterForeground: Signal<Void> {
        if let signal = bindingCache[cacheKey("willEnterForeground")] as? Signal<Void> {
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
            bindingCache[cacheKey("willEnterForeground")] = emitter
            bindingCache[cacheKey("willEnterForegroundClosure")] = closureHolder
            return emitter
        }
    }
    
    /// Application didBecomeActive signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var didBecomeActive: Signal<Void> {
        if let signal = bindingCache[cacheKey("didBecomeActive")] as? Signal<Void> {
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
            bindingCache[cacheKey("didBecomeActive")] = emitter
            bindingCache[cacheKey("didBecomeActiveClosure")] = closureHolder
            return emitter
        }
    }
    
    /// Application willResignActive signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var willResignActive: Signal<Void> {
        if let signal = bindingCache[cacheKey("willResignActive")] as? Signal<Void> {
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
            bindingCache[cacheKey("willResignActive")] = emitter
            bindingCache[cacheKey("willResignActiveClosure")] = closureHolder
            return emitter
        }
    }
    
    /// Application didEnterBackground signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var didEnterBackground: Signal<Void> {
        if let signal = bindingCache[cacheKey("didEnterBackground")] as? Signal<Void> {
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
            bindingCache[cacheKey("didEnterBackground")] = emitter
            bindingCache[cacheKey("didEnterBackgroundClosure")] = closureHolder
            return emitter
        }
    }
    
    /// Application willTerminate signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var willTerminate: Signal<Void> {
        if let signal = bindingCache[cacheKey("willTerminate")] as? Signal<Void> {
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
            bindingCache[cacheKey("willTerminate")] = emitter
            bindingCache[cacheKey("willTerminateClosure")] = closureHolder
            return emitter
        }
    }
    
    /// Application didReceiveMemoryWarning signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var didReceiveMemoryWarning: Signal<Void> {
        if let signal = bindingCache[cacheKey("didReceiveMemoryWarning")] as? Signal<Void> {
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
            bindingCache[cacheKey("didReceiveMemoryWarning")] = emitter
            bindingCache[cacheKey("didReceiveMemoryWarningClosure")] = closureHolder
            return emitter
        }
    }
}
