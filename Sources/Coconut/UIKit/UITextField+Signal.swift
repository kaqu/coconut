import Futura
import UIKit

extension SignalProducerAdapter where Subject: UITextField {
    public var text: Signal<String> {
        if let signal = bindingCache[cacheKey("textChange")] as? Emitter<String> {
            return signal
        } else {
            let emitter: Emitter<String> = .init()
            let closureHolder = ClosureHolder<UITextField>({
                emitter.emit($0?.text ?? "")
            })
            subject.addTarget(closureHolder, action: #selector(ClosureHolder<UITextField>.invoke), for: .editingChanged)
            bindingCache[cacheKey("textChange")] = emitter
            bindingCache[cacheKey("textChangeClosure")] = closureHolder
            return emitter.signal
        }
    }
}
