//
//  UserListViewModel.swift
//  SwiftRXExample
//
//  Created by Takeshi Kayahashi on 2022/07/11.
//

import Foundation
import RxSwift
import RxRelay

struct Response: Codable {
    let users: [User]
}

protocol UserListViewModelInput: AnyObject {
    
}

protocol UserListViewModelOutput: AnyObject {
    var title: Observable<String> { get }
    var users: Observable<[User]> { get }
}

class UserListViewModel: UserListViewModelInput, UserListViewModelOutput {
    
    private let disposeBag = DisposeBag()
    
    let title: Observable<String>

    // Observableでセクションの配列を公開
    private let usersSubject = BehaviorSubject<[User]>(value: [])
    var users: Observable<[User]> {
        return usersSubject.asObservable()
    }
    
    init() {
        let _title = BehaviorRelay(value: "SwiftRxExample")
        self.title = _title.asObservable()
    }
    
    func fetchUsers() {
        IndicatorView.shared.startIndicator()

        let url = URL(string: BASE_URL + API_URL + UserApi.all.rawValue)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.rx.response(request: request)
            .map { response, data in
                guard 200 ..< 300 ~= response.statusCode else {
                    throw ApiManager.ApiError.httpError(.init(statusCode: response.statusCode, message: response.description)) // サーバーエラーが発生した場合のエラーハンドリング
                }
                return data
            }
            .map{ data in
                try JSONDecoder().decode(Response.self, from: data).users
            }
            .subscribe(onNext: { [weak self] users in
                // データの変更を通知
                self?.usersSubject.onNext(users)
                IndicatorView.shared.stopIndicator()
//                self?.delegate?.didSuccessFetchUsers()
            }, onError: { [weak self] error in
                // エラーハンドリング
                self?.usersSubject.onError(error)
                IndicatorView.shared.stopIndicator()
            })
            .disposed(by: disposeBag)
        
    }
    
}

//protocol UserListViewModelDelegate: AnyObject {
//    func didSuccessFetchUsers()
//}
