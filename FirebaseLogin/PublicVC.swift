//
//  PublicVC.swift
//  FirebaseLogin
//
//  Created by alaattinbulut on 13.06.2021.
//

import UIKit
import AVFoundation
import Combine
import WidgetKit

class PublicVC: UIViewController {
    
    
    struct WidgetContent: TimelineEntry, Codable {
        var date: Date
        let imageURL: String
        let title: String
        let explanation: String
    }

    
    var contents: [WidgetContent] = [] {
      didSet {
        //writeContents()
      }

    }

    
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
    var stackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
    
    var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        FormStyleUtil.styleFilledButton(button)
        return button
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        FormStyleUtil.styleHollowButton(button)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        setupConstraints()
    }
    
    func writeContents() {
        
        var arr: [WidgetContent] = []
        
        let entry = WidgetContent(date: Date(), imageURL: "https://chatbot.denizbank.com/Content/files/Denizbank/Gorseller/Kolas.png", title: "AAATimeline", explanation: "Timeline")
        let entry2 = WidgetContent(date: Date(), imageURL: "https://chatbot.denizbank.com/Content/files/Denizbank/Gorseller/Kolas.png", title: "AAATimeline2", explanation: "Timeline")
        let entry3 = WidgetContent(date: Date(), imageURL: "https://chatbot.denizbank.com/Content/files/Denizbank/Gorseller/Kolas.png", title: "AAATimeline3", explanation: "Timeline")

        arr.append(entry)
        arr.append(entry2)
        arr.append(entry3)

        contents = arr

      //let widgetContents = contents
      
      let archiveURL = FileManager.sharedContainerURL()
        .appendingPathComponent("contents.json")
      print(">>> \(archiveURL)")
      let encoder = JSONEncoder()
      if let dataToSave = try? encoder.encode(contents) {
        do {
          try dataToSave.write(to: archiveURL)
        } catch {
          print("Error: Can't write contents")
          return
        }
      }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpVideo()
        writeContents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAndRemoveVideoElements()
    }
        
    private func setupView() {
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(loginButton)
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
            signUpButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            loginButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        let loginVC = LoginVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func setUpVideo() {
        
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        // Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width * 1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.8)
        
        // When it ends, replay it.
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem, queue: .main) {[weak self] _ in
            self?.videoPlayer?.seek(to: CMTime.zero)
            self?.videoPlayer?.play()
        }
    }

    private func stopAndRemoveVideoElements() {
        self.videoPlayerLayer?.removeFromSuperlayer()
        self.videoPlayer = nil
        self.videoPlayerLayer = nil
    }

}


extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.com.bulutoztemur.widget.contents"
    )!
  }
}
