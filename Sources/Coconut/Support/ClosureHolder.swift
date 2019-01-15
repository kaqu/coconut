import Foundation

internal class ClosureHolder<T> {
    private let closure: (T?) -> Void
    internal var cleanup: (() -> Void)?

    internal init(_ closure: @escaping (T?) -> Void) {
        self.closure = closure
    }

    @objc
    internal func invoke(with any: Any) {
        closure(any as? T)
    }

    deinit {
        cleanup?()
    }
}
