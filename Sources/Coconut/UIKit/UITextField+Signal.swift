import Futura
import UIKit

extension SignalConsumerAdapter where Subject: UITextField {
    /// Text signal input
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public var text: Signal<String>? {
        get {
            return loadCache(for: "text")
        }
        set {
            guard let inputSignal = newValue else {
                cache(nil, for: "text")
                cache(nil, for: "textCollector")
                return
            }
            let collector: SubscriptionCollector = .init()
            inputSignal
                .collect(with: collector)
                .values({ [weak subject] text in
                    dispatchPrecondition(condition: .onQueue(.main))
                    subject?.text = text
                })
            cache(inputSignal, for: "text")
            cache(collector, for: "textCollector")
        }
    }
}

extension SignalProducerAdapter where Subject: UITextField {
    /// Text editing changes (UIControl.Event.editingChanged) signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var textEdit: Signal<String> {
        if let signal: Signal<String> = loadCache(for: "textChange") {
            return signal
        } else {
            let emitter: Emitter<String> = .init()
            let closureHolder = ClosureHolder<UITextField>({
                emitter.emit($0?.text ?? "")
            })
            subject.addTarget(closureHolder, action: #selector(ClosureHolder<UITextField>.invoke), for: .editingChanged)
            cache(emitter, for: "textChange")
            cache(closureHolder, for: "textChangeClosure")
            return emitter.signal
        }
    }
    
    /// Editing state changes (UIControl.Event.editingDidBegin/UIControl.Event.editingDidEnd) signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public var editingChange: Signal<Bool> {
        if let signal: Signal<Bool> = loadCache(for: "editStateChange") {
            return signal
        } else {
            let emitter: Emitter<Bool> = .init()
            let beginClosureHolder = ClosureHolder<UITextField>({ _ in
                emitter.emit(true)
            })
            let endClosureHolder = ClosureHolder<UITextField>({ _ in
                emitter.emit(false)
            })
            subject.addTarget(beginClosureHolder, action: #selector(ClosureHolder<UITextField>.invoke), for: .editingDidBegin)
            subject.addTarget(endClosureHolder, action: #selector(ClosureHolder<UITextField>.invoke), for: .editingDidEnd)
            cache(emitter, for: "editStateChange")
            cache(beginClosureHolder, for: "editStateChangeBeginClosure")
            cache(endClosureHolder, for: "editStateChangeEndClosure")
            return emitter.signal
        }
    }
}

