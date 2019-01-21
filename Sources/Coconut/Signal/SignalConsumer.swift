import Foundation

/// SignalConsumer is a type that can produce signal inputs.
public protocol SignalConsumer: class {
    associatedtype Subject
    /// Input signals access
    var signalIn: SignalConsumerAdapter<Subject> { get }
}

fileprivate var signalConsumerAdapterKey: Int = 0
public extension SignalConsumer where Self: NSObject {
    var signalIn: SignalConsumerAdapter<Self> {
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

/// SignalConsumerAdapter allows easy extending and namespacing input signals.
public final class SignalConsumerAdapter<Subject> {
    public let subject: Subject
    private var bindingCache: [String: Any] = .init()

    public init(subject: Subject) {
        self.subject = subject
    }
    
    /// load value from local adapter cache
    public func loadCache<T>(for key: String) -> T? {
        return bindingCache[cacheKey(key)] as? T
    }
    
    /// cache valie in local adapter cache
    public func cache(_ any: Any?, for key: String) {
        bindingCache[cacheKey(key)] = any
    }
    
    private func cacheKey(_ string: String) -> String {
        return "\(Subject.self):\(string):Key"
    }
}

extension NSObject: SignalConsumer {}
