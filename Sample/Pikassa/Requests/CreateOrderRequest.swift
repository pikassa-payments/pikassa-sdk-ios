//
//  CreateOrderRequest.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 02.07.2020.
//

import Foundation


struct OrderRequest: Codable {
    let items: [Item]
    let customerPhone: String
    let customerEmail: String

    struct Item: Codable {
        let code: Int
        let count: Int
    }
}


struct CreateOrderResponse: Codable {
    let invoiceUuid: String
    let uuid: String
    let successUrl: String
    let failUrl: String
    let items: [Item]

    struct Item: Codable {
        let amount: Float
    }
}


class CreateOrderRequest: Request<CreateOrderResponse> {
    private let data: OrderRequest

    init(data: OrderRequest) {
        self.data = data

        super.init()

        self.method = .post
    }

    override func path() -> String {
        return "demo-shop/api/v1/orders"
    }

    override func body() -> Data? {
        return try? JSONEncoder().encode(self.data)
    }

    override func headers() -> [AnyHashable : Any]? {
        return [
            "x-api-key": "be4d9881-4af5-4969-bac0-dfe8491a333a",
            "content-Type": "application/json; charset=utf-8"
        ]
    }
}
