import Foundation

final class SessionUploadTask: URLSessionUploadTask {

    // MARK: - Types

    typealias Completion = (Data?, Foundation.URLResponse?, NSError?) -> Void

    // MARK: - Properties

    weak var session: Session!
    let request: URLRequest
    private let injectedIdentifier: Int
    let completion: Completion?
    let dataTask: SessionDataTask

    override var taskIdentifier: Int {
        return injectedIdentifier
    }

    // MARK: - Initializers

    init(session: Session, request: URLRequest, taskIdentifier: Int, completion: Completion? = nil) {
        self.session = session
        self.request = request
        self.injectedIdentifier = taskIdentifier
        self.completion = completion
        dataTask = SessionDataTask(session: session, request: request, taskIdentifier: session.nextTaskIdentifier(), completion: completion)
    }

    // MARK: - URLSessionTask

    override func cancel() {
        // Don't do anything
    }

    override func resume() {
        dataTask.resume()
    }
}
