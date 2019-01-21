import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UIButton {
    /// Title set signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public subscript(titleFor state: UIControl.State) -> Signal<String>? {
        get {
            return loadCache(for: "titleFor:\(state)")
        }
        set {
            guard let inputSignal = newValue else {
                cache(nil, for: "titleFor:\(state)")
                cache(nil, for: "titleCollectorFor:\(state)")
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] title in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.setTitle(title, for: .normal)
                })
            cache(inputSignal, for: "titleFor:\(state)")
            cache(collector, for: "titleCollectorFor:\(state)")
        }
    }
}
