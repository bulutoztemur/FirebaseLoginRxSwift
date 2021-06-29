//
//  CustomTextField.swift
//  FirebaseLogin
//
//  Created by alaattinbulut on 13.06.2021.
//

import UIKit

class CustomTextField: UITextField {
    
    var rightButton: UIButton?
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        changeStyle()
    }
    
    private func changeStyle() {
        FormStyleUtil.styleTextField(self)
    }
    
    func setPlaceholderText(text: String, color: UIColor = .gray) {
        attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func setInputModePassword() {
        isSecureTextEntry = true
        rightButton = UIButton()
        rightButton?.setImage(UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton?.addTarget(self, action: #selector(showPasswordTapped), for: .touchUpInside)
        rightButton?.tintColor = .black
        rightView = rightButton
        rightViewMode = UITextField.ViewMode.always
    }
    
    @objc func showPasswordTapped() {
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            rightButton?.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            rightButton?.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
}
