import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UILabel {
    /// Text signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public var text: Signal<String>? {
        get {
            return loadCache(for: "title")
        }
        set {
            guard let inputSignal = newValue else {
                cache(nil, for: "title")
                cache(nil, for: "titleCollector")
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] text in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.text = text
                })
            cache(inputSignal, for: "title")
            cache(collector, for: "titleCollector")
        }
    }
}
