//
//  UIViewController+Extensions.swift
//  FirebaseLogin
//
//  Created by alaattinbulut on 16.06.2021.
//

import UIKit

extension UIViewController {
    func customizeNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.addTarget(self, action: #selector(backmenu), for: .touchUpInside)
        leftButton.tintColor = .white
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func backmenu() {
        self.navigationController?.popViewController(animated: true)
    }
}
