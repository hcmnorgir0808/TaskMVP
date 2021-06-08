//
//  MVCViewController.swift
//  TaskMVP
//
//  Created by  on 2021/3/10.
//

import UIKit
import RxCocoa
import RxSwift

/*
 MVC構成になっています、MVP構成に変えてください

 Viewから何かを渡す、Viewが何かを受け取る　以外のことを書かない
 if, guard, forといった制御を入れない
 Presenter以外のクラスを呼ばない
 itemsといった変化するパラメータを持たない(状態を持たない)
*/

final class MVVMSearchViewController: UIViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: MVVMTableViewCell.className, bundle: nil), forCellReuseIdentifier: MVVMTableViewCell.className)
            tableView.dataSource = self
        }
    }
    
    private let viewModel = MVVMSearchViewModel()
    private lazy var input: MVVMSearchViewModelInput = viewModel
    private lazy var output: MVVMSearchViewModelOutput = viewModel
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindInputStream()
        bindOutputStream()
    }
    
    private func bindInputStream() {
        // 検索ボタンタップのイベント渡す
        let searchButtonObservable = searchButton.rx.tap
            .map { [weak self] in
                self?.searchTextField.text
            }
        searchButtonObservable.bind(to: input.searchTextObserver)
            .disposed(by: disposeBag)
        
        // tableViewのセルタップ
        let didSelectRowObservable = tableView.rx.itemSelected.map { $0.row }
        didSelectRowObservable.bind(to: input.didSelectRowObserver)
            .disposed(by: disposeBag)
    }
    
    private func bindOutputStream() {
        output.loadingStateObservable
            .bind(to: Binder(self) { vc, isLoading in
                vc.tableView.isHidden = isLoading
                vc.indicator.isHidden = !isLoading
            }).disposed(by: disposeBag)
        
        output.changeModelObservable
            .bind(to: Binder(self) { vc, _ in
                vc.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        output.selectGithubModelObservable
            .bind(to: Binder(self) { vc, model in
                Router.shared.showWeb(from: vc, githubModel: model)
            }).disposed(by: disposeBag)
    }
}

extension MVVMSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MVVMTableViewCell.className) as? MVVMTableViewCell else {
            fatalError()
        }
        let githubModel = output.models[indexPath.row]
        cell.configure(githubModel: githubModel)
        return cell
    }
}
