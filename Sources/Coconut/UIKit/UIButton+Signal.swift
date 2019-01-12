import Futura
import UIKit

extension SignalProducerAdapter where Subject: UIButton {
    public var tap: Signal<Void> {
        if let signal = bindingCache[cacheKey("tap")] as? Emitter<Void> {
            return signal
        } else {
            let emitter: Emitter<Void> = .init()
            let closureHolder = ClosureHolder<UIButton>({ _ in
                emitter.emit(Void())
            })
            subject.addTarget(closureHolder, action: #selector(ClosureHolder<UIButton>.invoke), for: .touchUpInside)
            bindingCache[cacheKey("tap")] = emitter
            bindingCache[cacheKey("tapClosure")] = closureHolder
            return emitter
        }
    }
}

extension SignalConsumerAdapter where Subject: UIButton {
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
