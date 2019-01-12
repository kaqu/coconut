import Foundation

public protocol SignalProducer {
    associatedtype Subject
    var signal: SignalProducerAdapter<Subject> { get }
}

fileprivate var signalProducerAdapterKey: Int = 0
public extension SignalProducer {
    var signal: SignalProducerAdapter<Self> {
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

import class Foundation.NSObject

extension NSObject: SignalProducer {}
