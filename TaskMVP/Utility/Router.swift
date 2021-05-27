//
//  Router.swift
//  TaskMVP
//
//  Created by sakiyamaK on 2021/03/10.
//

import UIKit

/*
 MVC構成用のUtilityです
 PresenterとViewControllerを繋ぐ処理はここに書きます
 本来はここもProtocolがいいですが、模範解答もprotocolは導入してません
 */

final class Router {
    static let shared = Router()
    private init() {}
    
    private var window: UIWindow?
    
    func showRoot(window: UIWindow) {
        guard let vc = UIStoryboard(name: MVVMSearchViewController.className, bundle: nil).instantiateInitialViewController() as? MVVMSearchViewController else {
            return
        }
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func showWeb(from: UIViewController, githubModel: GithubModel) {
        guard let vc = UIStoryboard(name: WebViewController.className, bundle: nil).instantiateInitialViewController() as? WebViewController else {
            return
        }
        
        let viewModel = WebViewModel(model: githubModel)
        vc.inject(viewModel: viewModel)
        show(from: from, to: vc)
    }
    
    private func show(from: UIViewController, to: UIViewController, completion:(() -> Void)? = nil){
        if let nav = from.navigationController {
            nav.pushViewController(to, animated: true)
            completion?()
        } else {
            from.present(to, animated: true, completion: completion)
        }
    }
}
