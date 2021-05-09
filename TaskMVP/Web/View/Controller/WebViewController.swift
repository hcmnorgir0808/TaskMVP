//
//  WebViewController.swift
//  TaskMVP
//
//  Created by  on 2021/3/10.
//

import UIKit
import WebKit

/*
 MVC構成になっています、MVP構成に変えてください

 Viewから何かを渡す、Viewが何かを受け取る　以外のことを書かない
 if, guard, forといった制御を入れない
 Presenter以外のクラスを呼ばない
 githubModelといった変化するパラメータを持たない(状態を持たない)
 */

final class WebViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    
    var presenter: WebViewPresenterInput?
    
    func inject(presenter: WebViewPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let model = presenter?.githubModel,
            let url = URL(string: model.urlStr) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
}
