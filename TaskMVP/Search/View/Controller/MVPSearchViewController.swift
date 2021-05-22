//
//  MVCViewController.swift
//  TaskMVP
//
//  Created by  on 2021/3/10.
//

import UIKit

/*
 MVC構成になっています、MVP構成に変えてください

 Viewから何かを渡す、Viewが何かを受け取る　以外のことを書かない
 if, guard, forといった制御を入れない
 Presenter以外のクラスを呼ばない
 itemsといった変化するパラメータを持たない(状態を持たない)
*/

protocol GithubSearchPresenterOutput: AnyObject {
    func updateData()
    func update(loading: Bool)
    func showWeb(githubModel: GithubModel)
    func get(error: Error)
}

final class MVPSearchViewController: UIViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton! {
        didSet {
            searchButton.addTarget(self, action: #selector(tapSearchButton(_sender:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: MVPTableViewCell.className, bundle: nil), forCellReuseIdentifier: MVPTableViewCell.className)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var presenter: GithubSearchPresenterInput?
    
    func inject(presenter: GithubSearchPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        indicator.isHidden = true
    }
    
    @objc func tapSearchButton(_sender: UIResponder) {
        presenter?.tapSearchButton(searchWord: searchTextField.text)
    }
}

extension MVPSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.didSelect(at: indexPath.item)
    }
}

extension MVPSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MVPTableViewCell.className) as? MVPTableViewCell,
              let githubModel = presenter?.item(at: indexPath.item) else {
            fatalError()
        }
        
        cell.configure(githubModel: githubModel)
        return cell
    }
}

extension MVPSearchViewController: GithubSearchPresenterOutput {
    func updateData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func update(loading: Bool) {
        DispatchQueue.main.async {
            self.indicator.isHidden = !loading
            self.tableView.isHidden = loading
        }
    }
    
    func showWeb(githubModel: GithubModel) {
        Router.shared.showWeb(from: self, githubModel: githubModel)
    }
    
    func get(error: Error) {
        print(error)
    }
}
