import Foundation
import Futura

public extension URLSession {
    
    /// Calls given request imediately. Returns Future covering result of call. Uses `dataTask(with:)` under the hood.
    ///
    /// - Parameter request: A URL request object that provides the URL, cache policy, request type, body data or body stream, and so on.
    /// - Returns: Future of call result. Succeds with any valid response or fails with URLSession error.
    /// - SeeAlso: `dataTask(with:)`
    func dataTaskFuture(with request: URLRequest) -> Future<(response: URLResponse, body: Data?)> {
        let promise: Promise<(response: URLResponse, body: Data?)> = .init()
        dataTask(with: request) { data, response, error in
            if let error = error {
                promise.break(with: error)
            } else if let response = response {
                promise.fulfill(with: (response, data))
            } else { // this is invalid state
                assertionFailure()
                promise.cancel()
            }
        }.resume()
        return promise.future
    }
}
