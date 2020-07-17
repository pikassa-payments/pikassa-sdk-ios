//
//  WebViewController.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 02.07.2020.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet private weak var webView: WKWebView!

    var url: URL!
    var didDismissBlock: (() -> Void)?
    var redirectURLs: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let req: URLRequest = URLRequest(url: self.url)
        self.webView.load(req)
        self.webView.navigationDelegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.didDismissBlock?()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url: URL = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        if redirectURLs.firstIndex(of: url) != nil {
            decisionHandler(.cancel)
            let blk: (() -> Void)? = self.didDismissBlock
            self.didDismissBlock = nil
            self.dismiss(animated: true, completion: blk)
            return
        }

        decisionHandler(.allow)
    }
}
