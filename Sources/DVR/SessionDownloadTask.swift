import Foundation

final class SessionDownloadTask: URLSessionDownloadTask {

    // MARK: - Types

    typealias Completion = (URL?, Foundation.URLResponse?, NSError?) -> Void

    // MARK: - Properties

    weak var session: Session!
    let request: URLRequest
    private let injectedIdentifier: Int
    let completion: Completion?

    override var taskIdentifier: Int {
        return injectedIdentifier
    }

    // MARK: - Initializers

    init(session: Session, request: URLRequest, taskIdentifier: Int, completion: Completion? = nil) {
        self.session = session
        self.request = request
        self.injectedIdentifier = taskIdentifier
        self.completion = completion
    }

    // MARK: - URLSessionTask

    override func cancel() {
        // Don't do anything
    }

    override func resume() {
        // same ID?
        let task = SessionDataTask(session: session, request: request, taskIdentifier: session.nextTaskIdentifier()) { data, response, error in
            let location: URL?
            if let data = data {
                // Write data to temporary file
                let tempURL = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent(UUID().uuidString))
                try? data.write(to: tempURL, options: [.atomic])
                location = tempURL
            } else {
                location = nil
            }

            self.completion?(location, response, error)
        }
        task.resume()
    }
}
