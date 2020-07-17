//
//  Request.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 02.07.2020.
//

import Foundation


internal enum Result<T> {
    case success(T)
    case fail(Error)
}


internal enum RequestMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}


class PikassaError: Error, LocalizedError {
    private let message: String
    let code: Int?
    var errorDescription: String? { return self.message }
    var failureReason: String? { return self.message }
    var recoverySuggestion: String? { return "" }
    var helpAnchor: String? { return "" }

    init(message: String, code: Int? = nil) {
        self.message = message
        self.code = code
    }
}


public class Request<T: Decodable> {
    var basePath: String = "https://pikassa.io"
    var method: RequestMethod = .get
    var rootKey: String? = "data"
    let errorsKey: String = "error"
    let successKey: String = "success"

    func perform(completion: ((Result<T>) -> Void)?) {
        guard let request: URLRequest = self.request() else {
            completion?(Result<T>.fail(PikassaError(message: "Can't create URL request")))
            return
        }

        print(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "NO BODY")

        let session: URLSession = self.session()

        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            DispatchQueue.main.async {
                completion?(self.parseReponse(response: response, data: data, error: error))
            }
        }

        task.resume()
    }

    func request() -> URLRequest? {
        guard let url = self.url() else {
            assertionFailure("Can't create URLRequest")
            return nil
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.httpBody = self.body()

        return request
    }

    func body() -> Data? {
        return nil
    }

    func url() -> URL? {
        return URL(string: "\(self.basePath)/\(self.path())")
    }

    func session() -> URLSession {
        let configuration: URLSessionConfiguration = .default
        configuration.httpAdditionalHeaders = self.headers()

        return URLSession(configuration: configuration)
    }

    func path() -> String {
        return ""
    }

    func headers() -> [AnyHashable: Any]? {
        return nil
    }

    func parseReponse(response: URLResponse?, data: Data?, error: Error?) -> Result<T> {
        print(response ?? "NO RESPONSE INFO")
        print(String(data: data ?? Data(), encoding: .utf8) ?? "NO RESPONSE DATA")

        if let error = error {
            return .fail(error)
        }

        guard let data = data else {
            return .fail(PikassaError(message: "No data"))
        }

        guard let dict: NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)) as? NSDictionary else {
            assertionFailure("Invalid data")
            return .fail(PikassaError(message: "Invalid data"))
        }

        print(dict)

        if let responseError: Error = self.extractError(dict: dict) {
            return .fail(responseError)
        }

        if !self.isSuccess(dict: dict) {
            return .fail(PikassaError(message: "Unknown error"))
        }

        if let rootKey: String = self.rootKey {
            let data: Any? = dict.object(forKey: rootKey)

            guard let keyData: [String: Any?] = data as? [String: Any?] else {
                assertionFailure("No data for key '\(rootKey)'")
                return .fail(PikassaError(message: "No data for key '\(rootKey)'"))
            }

            guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: keyData, options: .init()), let value: T = try? JSONDecoder().decode(T.self, from: jsonData) else {
                assertionFailure("Invalid data")
                return .fail(PikassaError(message: "Invalid data"))
            }

            return .success(value)
        } else {
            guard let value: T = try? JSONDecoder().decode(T.self, from: data) else {
                assertionFailure("Invalid data")
                return .fail(PikassaError(message: "Invalid data"))
            }

            return .success(value)
        }
    }

    private func extractError(dict: NSDictionary) -> Error? {
        if let error: [String: Any?] = dict.object(forKey: self.errorsKey) as? [String: Any?],
            let message: String = error["Message"] as? String, let strCode: String = error["Code"] as? String, let code: Int = Int(strCode) {
            return PikassaError(message: message, code: code)
        }

        return nil
    }

    private func isSuccess(dict: NSDictionary) -> Bool {
        if let success: Int = dict.object(forKey: self.successKey) as? Int  {
            return (success == 1)
        }

        if let success: String = dict.object(forKey: self.successKey) as? String {
            return (success.lowercased() == "true")
        }

        return false
    }
}
