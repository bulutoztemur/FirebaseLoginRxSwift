//
//  LoginVM.swift
//  FirebaseLogin
//
//  Created by alaattinbulut on 21.06.2021.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class LoginVM {
    let usernameTextBehaviorRelay = BehaviorRelay<String>(value: "")
    let passwordTextBehaviorRelay = BehaviorRelay<String>(value: "")
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(usernameTextBehaviorRelay, passwordTextBehaviorRelay)
                .map { username, password in
                    return ValidatorsUtil.usernameValidator(inputText: username.trimmingCharacters(in: .whitespacesAndNewlines)) &&
                            ValidatorsUtil.passwordValidator(inputText: password.trimmingCharacters(in: .whitespacesAndNewlines))
                }
    }
    
    func loginRequest(succeed: @escaping () -> ()) {
        FirebaseAuth.Auth.auth().signIn(withEmail: usernameTextBehaviorRelay.value, password: passwordTextBehaviorRelay.value) { result, error in
            succeed()
        }
    }
    
    func transitionToHome() {
    }
}
