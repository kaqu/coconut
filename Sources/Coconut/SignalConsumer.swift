import Foundation

public protocol SignalConsumer {
    associatedtype Subject
    var signalInput: SignalConsumerAdapter<Subject> { get }
}

fileprivate var signalConsumerAdapterKey: Int = 0
public extension SignalConsumer {
    var signalInput: SignalConsumerAdapter<Self> {
        get {
            if let adapter = objc_getAssociatedObject(self, &signalConsumerAdapterKey) as? SignalConsumerAdapter<Self> {
                return adapter
            } else {
                let adapter = SignalConsumerAdapter<Self>(subject: self)
                objc_setAssociatedObject(self,
                                         &signalConsumerAdapterKey,
                                         adapter,
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return adapter
            }
        }
    }
}

public final class SignalConsumerAdapter<Subject> {
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

extension NSObject: SignalConsumer {}
