//
//  SignUpVM.swift
//  FirebaseLogin
//
//  Created by alaattinbulut on 17.06.2021.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseFirestore

class SignUpVM {
    let usernameTextBehaviorRelay = BehaviorRelay<String>(value: "")
    let emailTextBehaviorRelay = BehaviorRelay<String>(value: "")
    let fullnameTextBehaviorRelay = BehaviorRelay<String>(value: "")
    let passwordTextBehaviorRelay = BehaviorRelay<String>(value: "")
        
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(usernameTextBehaviorRelay, emailTextBehaviorRelay, fullnameTextBehaviorRelay, passwordTextBehaviorRelay)
                .map { username, email, fullname, password in
                    return ValidatorsUtil.usernameValidator(inputText: username.trimmingCharacters(in: .whitespacesAndNewlines)) &&
                            ValidatorsUtil.emailValidator(inputText: email.trimmingCharacters(in: .whitespacesAndNewlines)) &&
                            ValidatorsUtil.fullnameValidator(inputText: fullname.trimmingCharacters(in: .whitespacesAndNewlines)) &&
                            ValidatorsUtil.passwordValidator(inputText: password.trimmingCharacters(in: .whitespacesAndNewlines))
                }
    }
    
    func signUpRequest(errorHandler: @escaping () -> ()) {
        FirebaseAuth.Auth.auth().createUser(withEmail: emailTextBehaviorRelay.value, password: passwordTextBehaviorRelay.value) { [weak self] result, error in
            guard let self = self else { return }
            
            guard error == nil else {
                errorHandler()
                return
                
            }
            
            print("account created")
            
             let db = Firestore.firestore()
            db.collection("users")
                .addDocument(data: ["username": self.usernameTextBehaviorRelay.value,
                                    "fullname": self.fullnameTextBehaviorRelay.value,
                                    "uid": result!.user.uid]) { (error) in
             }
             
        }
    }
}
