import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UIControl {
    public var interactionsEnabled: Signal<Bool>? {
        get {
            return bindingCache[cacheKey("interactionsEnabled")] as? Signal<Bool>
        }
        set {
            guard let inputSignal = newValue else {
                bindingCache[cacheKey("interactionsEnabled")] = nil
                bindingCache[cacheKey("interactionsEnabledCollector")] = nil
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] interactionsEnabled in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.isUserInteractionEnabled = interactionsEnabled
                })
            
            bindingCache[cacheKey("interactionsEnabled")] = inputSignal
            bindingCache[cacheKey("interactionsEnabledCollector")] = collector
        }
    }
}

extension SignalConsumerAdapter where Subject: UIControl {
    public var enabled: Signal<Bool>? {
        get {
            return bindingCache[cacheKey("enabled")] as? Signal<Bool>
        }
        set {
            guard let inputSignal = newValue else {
                bindingCache[cacheKey("enabled")] = nil
                bindingCache[cacheKey("enabledCollector")] = nil
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] enabled in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.isEnabled = enabled
                })
            bindingCache[cacheKey("enabled")] = inputSignal
            bindingCache[cacheKey("enabledCollector")] = collector
        }
    }
}
