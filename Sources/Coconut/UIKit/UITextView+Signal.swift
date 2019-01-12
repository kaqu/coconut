import Futura
import UIKit

extension SignalProducerAdapter where Subject: UITextView {
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
