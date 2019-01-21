import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UIControl {
    /// User interaction state (isUserInteractionEnabled) signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public var interactionsEnabled: Signal<Bool>? {
        get {
            return loadCache(for: "interactionsEnabled")
        }
        set {
            guard let inputSignal = newValue else {
                cache(nil, for: "interactionsEnabled")
                cache(nil, for: "interactionsEnabledCollector")
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] interactionsEnabled in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.isUserInteractionEnabled = interactionsEnabled
                })
            
            cache(inputSignal, for: "interactionsEnabled")
            cache(collector, for: "interactionsEnabledCollector")
        }
    }
}

extension SignalConsumerAdapter where Subject: UIControl {
    /// Enabled state (isEnabled) signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public var enabled: Signal<Bool>? {
        get {
            return loadCache(for: "enabled")
        }
        set {
            guard let inputSignal = newValue else {
                cache(nil, for: "enabled")
                cache(nil, for: "enabledCollector")
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] enabled in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.isEnabled = enabled
                })
            cache(inputSignal, for: "enabled")
            cache(collector, for: "enabledCollector")
        }
    }
}

extension SignalProducerAdapter where Subject: UIControl {
    /// Tap (UIControl.Event.touchUpInside) output signal
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var tap: Signal<Void> {
        if let signal: Signal<Void> = loadCache(for: "tap") {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIButton>({ _ in
                emitter.emit()
            })
            subject.addTarget(closureHolder, action: #selector(ClosureHolder<UIButton>.invoke), for: .touchUpInside)
            cache(emitter, for: "tap")
            cache(closureHolder, for: "tapClosure")
            return emitter
        }
    }
}
