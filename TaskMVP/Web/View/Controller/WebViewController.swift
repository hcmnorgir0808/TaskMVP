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

protocol WebViewPresenterOutput: AnyObject {
    func load(url: URL)
}

final class WebViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    
    private var viewModel: WebViewModel!
    private lazy var output: WebViewModelOutput = viewModel
    
    func inject(viewModel: WebViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: output.model.urlStr) else { return }
        
        webView.load(URLRequest(url: url))
    }
}
