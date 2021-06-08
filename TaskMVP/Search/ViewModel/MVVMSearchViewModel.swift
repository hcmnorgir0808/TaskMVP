//
//  MVVMSearchViewModel.swift
//  TaskMVP
//
//  Created by 岩本康孝 on 2021/05/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol MVVMSearchViewModelInput: AnyObject {
    var searchTextObserver: AnyObserver<String?> { get }
    var didSelectRowObserver: AnyObserver<Int> { get }
}

protocol MVVMSearchViewModelOutput {
    var loadingStateObservable: Observable<Bool> { get }
    var changeModelObservable: Observable<[GithubModel]> { get }
    var selectGithubModelObservable: Observable<GithubModel> { get }
    var models: [GithubModel] { get }
}

final class MVVMSearchViewModel: MVVMSearchViewModelInput, MVVMSearchViewModelOutput {
    lazy var searchTextObserver: AnyObserver<String?> = .init { [weak self] (event) in
        // 空文字またはnilの場合はreturn
        guard let element = event.element,
              let searchText = element,
              !searchText.isEmpty else { return }
        
        // loading開始
        self?._loadingState.accept(true)
        // APIを叩く
        self?._searchText.accept(searchText)
    }
    
    lazy var didSelectRowObserver: AnyObserver<Int> = .init { [weak self] (event) in

        guard let index = event.element,
              let self = self else { return }
        self._selectGithubModel.accept(self.models[index])
    }
    
    private let _loadingState = PublishRelay<Bool>()
    private let _searchText = PublishRelay<String>()
    
    private let _changeModel = PublishRelay<[GithubModel]>()
    
    private let _selectGithubModel = PublishRelay<GithubModel>()
    
    
    lazy var loadingStateObservable = _loadingState.asObservable()
    lazy var changeModelObservable = _changeModel.asObservable()
    lazy var selectGithubModelObservable = _selectGithubModel.asObservable()
    
    private let disposeBag = DisposeBag()
    
    private(set) var models = [GithubModel]()
    
    init() {
        _searchText.subscribe(onNext: { [weak self] (searchText) in
            guard let self = self else { return }
            // Observableが帰ってくる
            GithubAPI.shared.rx.get(searchWord: searchText)
                .map { [weak self] models in
                    self?._loadingState.accept(false)
                    self?.models = models
                    return models
                }
                .bind(to: self._changeModel).disposed(by: self.disposeBag)
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
}
