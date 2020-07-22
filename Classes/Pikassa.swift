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

    public func sendCardData(_ cardData: BankCardDetails,
                             invoiceId: String,
                             didSuccessBlock: ((PayResponse) -> Void)?,
                             didFailBlock: ((Error) -> Void)?) {
        self.doSendCardData(cardData,
                            invoiceId: invoiceId,
                            requestId: UUID().uuidString,
                            apiKey: Pikassa.apiKey,
                            didSuccessBlock: didSuccessBlock,
                            didFailBlock: didFailBlock)
    }

    private func doSendCardData(_ cardData: BankCardDetails,
                                invoiceId: String,
                                requestId: String,
                                apiKey: String,
                                didSuccessBlock: ((PayResponse) -> Void)?,
                                didFailBlock: ((Error) -> Void)?) {
        if Pikassa.apiKey == nil {
            assertionFailure("In order to use Pikassa SDK you need to pass API-key via Pikassa.setUp(apiKey: String)")
            return
        }

        let body: PayRequest.Body = PayRequest.Body(requestId: requestId, paymentMethod: PaymentMethods.bankCard.rawValue, details: cardData)

        let req: PayRequest = PayRequest(cardDetails: body, invoiceId: invoiceId)
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

public struct BankCardDetails: Codable {
    let pan: String
    let cardHolder: String
    let cvc: String
    let expYear: String
    let expMonth: String
    let someParam: [String: String]?

    public init(pan: String, cardHolder: String, cvc: Int, expYear: Int, expMonth: Int, params: [String: String]? = nil) {
        self.pan = pan
        self.cardHolder = cardHolder
        self.cvc = "\(cvc)"
        self.expYear = "\(expYear)"
        self.expMonth = "\(expMonth)"
        self.someParam = params
    }
}

public enum PaymentMethods: String {
    case bankCard = "BankCard";
    case webMoney = "WMR";
    case yandexMoney = "YandexMoney";
    case mobile = "Mobile";
}
