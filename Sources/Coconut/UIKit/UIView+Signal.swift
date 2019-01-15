import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UIView {
    /// Hidden state (isHidden) signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public var hidden: Signal<Bool>? {
        get {
            return bindingCache[cacheKey("hidden")] as? Signal<Bool>
        }
        set {
            guard let inputSignal = newValue else {
                bindingCache[cacheKey("hidden")] = nil
                bindingCache[cacheKey("hiddenCollector")] = nil
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] hidden in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.isHidden = hidden
                })
            bindingCache[cacheKey("hidden")] = inputSignal
            bindingCache[cacheKey("hiddenCollector")] = collector
        }
    }
}
