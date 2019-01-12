import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UILabel {
    public var text: Signal<String>? {
        get {
            return bindingCache[cacheKey("title")] as? Signal<String>
        }
        set {
            guard let inputSignal = newValue else {
                bindingCache[cacheKey("title")] = nil
                bindingCache[cacheKey("titleCollector")] = nil
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] text in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.text = text
                })
            bindingCache[cacheKey("title")] = inputSignal
            bindingCache[cacheKey("titleCollector")] = collector
        }
    }
}
