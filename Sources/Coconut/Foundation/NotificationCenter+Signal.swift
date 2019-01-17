import Foundation
import Futura

extension SignalProducerAdapter where Subject: NotificationCenter {
    /// Text changes (UIControl.Event.editingChanged) signal output
    /// This signal lifetime is corresponding to its subject - if subject becomes deallocated signal will become ended.
    ///
    /// - Warning: use `collect(with:)` before adding any transformations or handlers to this signal if you need to
    /// unbind while subject is still alive.
    public subscript(notificationName name: Notification.Name) -> Signal<Notification> {
        if let signal = bindingCache[cacheKey("notificationsFor:\(name)")] as? Signal<Notification> {
            return signal
        } else {
            let emitter: Emitter<Notification> = .init()
            let closureHolder = ClosureHolder<Notification>({
                guard let notification = $0 else { return }
                emitter.emit(notification)
            })
            closureHolder.cleanup = { NotificationCenter.default.removeObserver(closureHolder) }
            NotificationCenter.default
                .addObserver(closureHolder,
                             selector: #selector(ClosureHolder<Notification>.invoke),
                             name: name,
                             object: nil)
            bindingCache[cacheKey("notificationsFor:\(name)")] = emitter
            bindingCache[cacheKey("notificationsFor:\(name) Closure")] = closureHolder
            return emitter
        }
    }
}
