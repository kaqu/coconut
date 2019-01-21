import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UITextView {
    /// Text signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public var text: Signal<String>? {
        get {
            return loadCache(for:"text")
        }
        set {
            guard let inputSignal = newValue else {
                cache(nil, for: "text")
                cache(nil, for: "textCollector")
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] text in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.text = text
                })
            cache(inputSignal, for: "text")
            cache(collector, for: "textCollector")
        }
    }
}

extension SignalProducerAdapter where Subject: UITextView {
    /// Text changes (UITextView.textDidChangeNotification) signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var text: Signal<String> {
        if let signal: Signal<String> = loadCache(for:"textChange") {
            return signal
        } else {
            let emitter: Emitter<String> = .init()
            let closureHolder = ClosureHolder<UITextField>({
                emitter.emit($0?.text ?? "")
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<UITextField>.invoke),
                             name: UITextView.textDidChangeNotification,
                             object: subject)
            cache(emitter, for: "textChange")
            cache(closureHolder, for: "textChangeClosure")
            return emitter
        }
    }
}
