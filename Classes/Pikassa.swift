//
//  Pikassa.swift
//  Pikassa
//
//  Created by pikassa.io on 29.06.2020.
//

import Foundation


public class Pikassa {
    public static let shared: Pikassa = Pikassa()
    private(set) static var apiKey: String!

    public static func setUp(apiKey: String) {
        Pikassa.apiKey = apiKey
    }
    
    public func sendPaymentData(method: PaymentMethods,
                                invoiceId: String,
                                didSuccessBlock: ((PayResponse) -> Void)?,
                                didFailBlock: ((Error) -> Void)?) {
        self.doSendPaymentData(method,
                               invoiceId: invoiceId,
                               requestId: UUID().uuidString,
                               apiKey: Pikassa.apiKey,
                               didSuccessBlock: didSuccessBlock,
                               didFailBlock: didFailBlock)
    }

    private func doSendPaymentData(_ method: PaymentMethods,
                                invoiceId: String,
                                requestId: String,
                                apiKey: String,
                                didSuccessBlock: ((PayResponse) -> Void)?,
                                didFailBlock: ((Error) -> Void)?) {
        if Pikassa.apiKey == nil {
            assertionFailure("In order to use Pikassa SDK you need to pass API-key via Pikassa.setUp(apiKey: String)")
            return
        }


        let req: PayRequest = PayRequest(
            encodedBody: method.paymentData(forRequestId: requestId),
            invoiceId: invoiceId)
        
        req.perform { (result: Result<PayResponse>) in
            switch result {
            case .success(let response):
                didSuccessBlock?(response)
            case .fail(let error):
                didFailBlock?(error)
            }
        }
    }
}
public protocol PaymentDetails: Codable {}

public struct BankCardDetails: PaymentDetails {
    let pan: String
    let cardHolder: String
    let cvc: String
    let expYear: String
    let expMonth: String

    public init(pan: String, cardHolder: String, cvc: Int, expYear: Int, expMonth: Int) {
        self.pan = pan
        self.cardHolder = cardHolder
        self.cvc = "\(cvc)"
        self.expYear = "\(expYear)"
        self.expMonth = "\(expMonth)"
    }
}

public enum PaymentMethods {
    case bankCard(details: BankCardDetails)
    
    case custom(details: [String: String])
    
    //TODO: Support types for other methods
    //case webMoney = "WMR";
    //case yandexMoney = "YandexMoney";
    //case mobile = "Mobile";
    internal func getApiAlias() -> String {
        switch self {
        case .bankCard:
            return "BankCard"
        case .custom(details: let details):
            return details["paymentMethod"] ?? "Unknown"
        }
    }
    
    internal func paymentData(forRequestId requestId: String) -> Data {
        switch self {
        case .bankCard(let details):
            let body = PayRequest.Body(requestId: requestId,
                                       paymentMethod: getApiAlias(),
                                       details: details)
            return (try? JSONEncoder().encode(body)) ?? Data()
            
        case .custom(let details):
            let body = PayRequest.Body(requestId: requestId,
                                       paymentMethod: getApiAlias(),
                                       details: details.filter({ $0.key != "paymentMethod" }))
            return (try? JSONEncoder().encode(body)) ?? Data()
        }
    }
}
