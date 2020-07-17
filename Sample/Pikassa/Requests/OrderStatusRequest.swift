//
//  OrderStatusRequest.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 02.07.2020.
//

import Foundation


struct OrderStatusResponse: Codable {
    let status: Status

    struct Status: Codable {
        let code: Int
    }
}


class OrderStatusRequest: Request<OrderStatusResponse> {
    let invoiceUUID: String

    init(invoiceUUID: String) {
        self.invoiceUUID = invoiceUUID

        super.init()

        self.method = .get
    }

    override func path() -> String {
        return "demo-shop/api/v1/orders/\(self.invoiceUUID)"
    }

    override func headers() -> [AnyHashable : Any]? {
        return [
            "x-api-key": "be4d9881-4af5-4969-bac0-dfe8491a333a",
            "content-Type": "application/json; charset=utf-8"
        ]
    }
}
