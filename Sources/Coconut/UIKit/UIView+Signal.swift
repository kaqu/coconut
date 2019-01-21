import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UIView {
    /// Hidden state (isHidden) signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public var hidden: Signal<Bool>? {
        get {
            return loadCache(for: "hidden")
        }
        set {
            guard let inputSignal = newValue else {
                cache(nil, for: "hidden")
                cache(nil, for: "hiddenCollector")
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] hidden in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.isHidden = hidden
                })
            cache(inputSignal, for: "hidden")
            cache(collector, for: "hiddenCollector")
        }
    }
}
