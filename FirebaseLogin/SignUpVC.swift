//
//  SignUpVC.swift
//  FirebaseLogin
//
//  Created by alaattinbulut on 13.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UIViewController {
    
    let vm = SignUpVM()
    let disposeBag = DisposeBag()
    var scrollViewBottomConstraint: NSLayoutConstraint?
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isScrollEnabled = true
        return sv
    }()
    
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
    
    var emailTF: FormInputField = {
        let inputField = FormInputField()
        inputField.customTF.setPlaceholderText(text: "Email")
        inputField.validationErrorLabel.text = "Please enter a valid email"
        inputField.customTF.autocorrectionType = .no
        inputField.customTF.autocapitalizationType = .none
        return inputField
    }()
    
    var fullnameTF: FormInputField = {
        let inputField = FormInputField()
        inputField.customTF.setPlaceholderText(text: "Full Name")
        inputField.validationErrorLabel.text = "Please enter a valid full name"
        return inputField
    }()
    
    var passwordTF: FormInputField = {
        let inputField = FormInputField()
        inputField.customTF.setPlaceholderText(text: "Password")
        inputField.validationErrorLabel.text = "Please make sure your password is at least 8 characters, contains at least \n \u{2022} 1 Uppercase Alphabet \n \u{2022} 1 Lowercase Alphabet \n \u{2022} 1 Number \n \u{2022} 1 Special Character (! % * ? & # . _)"
        inputField.customTF.setInputModePassword()
        return inputField
    }()
    
    var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        FormStyleUtil.styleFilledButton(button)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        addObserversForKeyboard()
        customizeNavigationBar()
        makeBindings()
        usernameTF.customTF.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Sign Up"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calculateScrollViewContentSize()
    }
    
    private func calculateScrollViewContentSize() {
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = CGSize(width: contentRect.size.width, height: contentRect.size.height)
    }
    
    private func setupViews() {
        stackView.addArrangedSubview(usernameTF)
        stackView.addArrangedSubview(emailTF)
        stackView.addArrangedSubview(fullnameTF)
        stackView.addArrangedSubview(passwordTF)
        stackView.addArrangedSubview(signUpButton)
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewBottomConstraint!,
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addObserversForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisapper),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            scrollViewBottomConstraint?.constant = -keyboardHeight
        }
    }
    
    @objc func keyboardWillDisapper(_ notification: Notification) {
        scrollViewBottomConstraint?.constant = 0
    }
    
    private func makeBindings() {
        usernameBinding()
        emailBinding()
        fullnameBinding()
        passwordBinding()
        
        /*
         usernameTF.customTF.rx.text.orEmpty.bind(to: vm.usernameTextBehaviorRelay).disposed(by: disposeBag)
         emailTF.customTF.rx.text.orEmpty.bind(to: vm.emailTextBehaviorRelay).disposed(by: disposeBag)
         fullnameTF.customTF.rx.text.orEmpty.bind(to: vm.fullnameTextBehaviorRelay).disposed(by: disposeBag)
         passwordTF.customTF.rx.text.orEmpty.bind(to: vm.passwordTextBehaviorRelay).disposed(by: disposeBag)
         */
        
        vm.isValid().bind(to: signUpButton.rx.isEnabled).disposed(by: disposeBag)
        vm.isValid().map { $0 ? 1 : 0.3 }.bind(to: signUpButton.rx.alpha).disposed(by: disposeBag)
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
    
    private func emailBinding() {
        emailTF.customTF.rx.controlEvent([.editingDidEnd, .editingChanged])
            .withLatestFrom(emailTF.customTF.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] myText in
                guard let self = self else { return }
                self.vm.emailTextBehaviorRelay.accept(myText)
                self.emailTF.validationErrorLabel.isHidden = ValidatorsUtil.emailValidator(inputText: myText)
                self.emailTF.customTF.invalidateIntrinsicContentSize()
            })
            .disposed(by: disposeBag)
    }
    
    private func fullnameBinding() {
        fullnameTF.customTF.rx.controlEvent([.editingDidEnd, .editingChanged])
            .withLatestFrom(fullnameTF.customTF.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] myText in
                guard let self = self else { return }
                self.vm.fullnameTextBehaviorRelay.accept(myText)
                self.fullnameTF.validationErrorLabel.isHidden = ValidatorsUtil.fullnameValidator(inputText: myText)
                self.fullnameTF.customTF.invalidateIntrinsicContentSize()
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
    
    
    @objc func signUpButtonTapped() {
        print("Button tapped")
        vm.signUpRequest {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
