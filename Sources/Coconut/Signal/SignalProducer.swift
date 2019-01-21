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

extension NSObject: SignalProducer {}
