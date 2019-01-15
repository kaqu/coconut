import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UITextView {
    /// Text signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public var text: Signal<String>? {
        get {
            return bindingCache[cacheKey("text")] as? Signal<String>
        }
        set {
            guard let inputSignal = newValue else {
                bindingCache[cacheKey("text")] = nil
                bindingCache[cacheKey("textCollector")] = nil
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] text in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.text = text
                })
            bindingCache[cacheKey("text")] = inputSignal
            bindingCache[cacheKey("textCollector")] = collector
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
        if let signal = bindingCache[cacheKey("textChange")] as? Emitter<String> {
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
            bindingCache[cacheKey("textChange")] = emitter
            bindingCache[cacheKey("textChangeClosure")] = closureHolder
            return emitter
        }
    }
}
