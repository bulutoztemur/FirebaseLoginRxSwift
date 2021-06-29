//
//  FormInputField.swift
//  FirebaseLogin
//
//  Created by alaattinbulut on 16.06.2021.
//

import UIKit

class FormInputField: UIView {
    
    var validationRegex: String?
    
    var stackview: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    let customTF: CustomTextField = CustomTextField()
    
    var validationErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.isHidden = true
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func configureViews() {
        stackview.addArrangedSubview(customTF)
        stackview.addArrangedSubview(validationErrorLabel)
        addSubview(stackview)
        
        NSLayoutConstraint.activate([
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor),            
            customTF.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
