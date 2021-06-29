//
//  LoginVC.swift
//  FirebaseLogin
//
//  Created by alaattinbulut on 16.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    
    let disposeBag = DisposeBag()
    let vm = LoginVM()
    
    var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        return sv
    }()
    
    var usernameTF: FormInputField = {
        let inputField = FormInputField()
        inputField.customTF.setPlaceholderText(text: "Username")
        inputField.validationErrorLabel.text = "Please enter a valid username"
        return inputField
    }()

    var passwordTF: FormInputField = {
        let inputField = FormInputField()
        inputField.customTF.setPlaceholderText(text: "Password")
        inputField.validationErrorLabel.text = "Please make sure your password is at least 8 characters, contains at least \n \u{2022} 1 Uppercase Alphabet \n \u{2022} 1 Lowercase Alphabet \n \u{2022} 1 Number \n \u{2022} 1 Special Character (! % * ? & # . _)"
        inputField.customTF.setInputModePassword()
        return inputField
    }()

    var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        FormStyleUtil.styleFilledButton(button)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        customizeNavigationBar()
        makeBindings()
        usernameTF.customTF.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Login"
    }
    
    private func setupViews() {
        stackView.addArrangedSubview(usernameTF)
        stackView.addArrangedSubview(passwordTF)
        stackView.addArrangedSubview(loginButton)
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func makeBindings() {
        usernameBinding()
        passwordBinding()
                
        vm.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        vm.isValid().map { $0 ? 1 : 0.3 }.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
    }

    
    private func usernameBinding() {
        usernameTF.customTF.rx.controlEvent([.editingDidEnd, .editingChanged])
            .withLatestFrom(usernameTF.customTF.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] myText in
                guard let self = self else { return }
                self.vm.usernameTextBehaviorRelay.accept(myText)
                self.usernameTF.validationErrorLabel.isHidden = ValidatorsUtil.usernameValidator(inputText: myText)
                self.usernameTF.customTF.invalidateIntrinsicContentSize()
            })
            .disposed(by: disposeBag)
    }

    private func passwordBinding() {
        passwordTF.customTF.rx.controlEvent([.editingDidEnd, .editingChanged])
            .withLatestFrom(passwordTF.customTF.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] myText in
                guard let self = self else { return }
                self.vm.passwordTextBehaviorRelay.accept(myText)
                self.passwordTF.validationErrorLabel.isHidden = ValidatorsUtil.passwordValidator(inputText: myText)
                self.passwordTF.customTF.invalidateIntrinsicContentSize()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func loginButtonTapped() {
        vm.loginRequest {
            let vc = UIViewController()
            vc.title = "ASDASDA"
            self.present(vc, animated: true, completion: nil)
        }
    }
    

}
