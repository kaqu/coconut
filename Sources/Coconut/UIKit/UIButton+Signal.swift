import Futura
import UIKit

extension SignalProducerAdapter where Subject: UIButton {
    /// Tap (UIControl.Event.touchUpInside) output signal
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var tap: Signal<Void> {
        if let signal = bindingCache[cacheKey("tap")] as? Signal<Void> {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIButton>({ _ in
                emitter.emit()
            })
            subject.addTarget(closureHolder, action: #selector(ClosureHolder<UIButton>.invoke), for: .touchUpInside)
            bindingCache[cacheKey("tap")] = emitter
            bindingCache[cacheKey("tapClosure")] = closureHolder
            return emitter
        }
    }
}

extension SignalConsumerAdapter where Subject: UIButton {
    /// Title set signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public subscript(titleFor state: UIControl.State) -> Signal<String>? {
        get {
            return bindingCache[cacheKey("titleFor:\(state)")] as? Signal<String>
        }
        set {
            guard let inputSignal = newValue else {
                bindingCache[cacheKey("titleFor:\(state)")] = nil
                bindingCache[cacheKey("titleCollectorFor:\(state)")] = nil
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] title in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.setTitle(title, for: .normal)
                })
            bindingCache[cacheKey("titleFor:\(state)")] = inputSignal
            bindingCache[cacheKey("titleCollectorFor:\(state)")] = collector
        }
    }
}
