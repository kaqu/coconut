import Foundation

/// SignalProducer is a type that can produce signal outputs.
public protocol SignalProducer: class {
    associatedtype Subject
    /// Output signals access
    var signalOut: SignalProducerAdapter<Subject> { get }
}

fileprivate var signalProducerAdapterKey: Int = 0
public extension SignalProducer where Self: NSObject {
    var signalOut: SignalProducerAdapter<Self> {
        get {
            if let adapter = objc_getAssociatedObject(self, &signalProducerAdapterKey) as? SignalProducerAdapter<Self> {
                return adapter
            } else {
                let adapter = SignalProducerAdapter<Self>(subject: self)
                objc_setAssociatedObject(self,
                                         &signalProducerAdapterKey,
                                         adapter,
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return adapter
            }
        }
    }
}

/// SignalProducerAdapter allows easy extending and namespacing output signals.
public final class SignalProducerAdapter<Subject> {
    internal let subject: Subject
    internal var bindingCache: [String: Any] = .init()

    internal init(subject: Subject) {
        self.subject = subject
    }

    internal func cacheKey(_ string: String) -> String {
        return "\(Subject.self):\(string):Key"
    }
}

extension NSObject: SignalProducer {}
