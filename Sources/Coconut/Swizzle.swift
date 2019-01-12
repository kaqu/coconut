import Foundation

internal func swizzleInstance(method originalSelector: Selector, with swizzledSelector: Selector, for classType: AnyClass) {
    guard let originalMethod = class_getInstanceMethod(classType, originalSelector),
        let swizzledMethod = class_getInstanceMethod(classType, swizzledSelector) else {
        return
    }

    let added = class_addMethod(classType,
                                originalSelector,
                                method_getImplementation(swizzledMethod),
                                method_getTypeEncoding(swizzledMethod))
    if added {
        class_replaceMethod(classType,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
