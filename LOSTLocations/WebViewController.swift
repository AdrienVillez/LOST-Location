//
//  WebViewController.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 10/17/18.
//  Copyright © 2018 AdrienVillez. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    private let privacyURL: String = "https://adrienvillez.com/ios-privacy-policy.html"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: privacyURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    
    @IBAction func exitViewControllerButtonTapped(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
}
