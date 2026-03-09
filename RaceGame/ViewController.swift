//
//  ViewController.swift
//  RaceGame
//
//  Created by Dmitry Divin on 13.11.25.
//

import UIKit
import SnapKit
import AVFoundation

// MARK: - ViewController
final class ViewController: UIViewController {
    
    // MARK: - UI Elements
    private let mainPicture: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MainConstants.String.mainBackground))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let soundButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: MainConstants.String.soundOnImage), for: .normal)
        button.setImage(UIImage(systemName: MainConstants.String.soundOffImage), for: .selected)
        button.tintColor = MainConstants.Color.soundButtonTint
        button.layer.cornerRadius = MainConstants.Animation.buttonCornerRadius
        button.backgroundColor = MainConstants.Color.buttonBackground
        return button
    }()
    
    private let startGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(MainConstants.String.startGame, for: .normal)
        button.setTitleColor(MainConstants.Color.buttonTitle, for: .normal)
        button.backgroundColor = MainConstants.Color.buttonBackground
        button.layer.cornerRadius = MainConstants.Animation.buttonCornerRadius
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(MainConstants.String.settings, for: .normal)
        button.setTitleColor(MainConstants.Color.buttonTitle, for: .normal)
        button.backgroundColor = MainConstants.Color.buttonBackground
        button.layer.cornerRadius = MainConstants.Animation.buttonCornerRadius
        return button
    }()
    
    private let recordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(MainConstants.String.records, for: .normal)
        button.setTitleColor(MainConstants.Color.buttonTitle, for: .normal)
        button.backgroundColor = MainConstants.Color.buttonBackground
        button.layer.cornerRadius = MainConstants.Animation.buttonCornerRadius
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        AudioManager.shared.updateButtonState(soundButton)
        
        if AudioManager.shared.isSoundEnabled() {
            AudioManager.shared.startBackgroundMusic()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.startGameButton.dropShadow(radius: MainConstants.Animation.shadowRadius)
        self.settingsButton.dropShadow(radius: MainConstants.Animation.shadowRadius)
        self.recordsButton.dropShadow(radius: MainConstants.Animation.shadowRadius)
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(mainPicture)
        mainPicture.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(soundButton)
        soundButton.snp.makeConstraints { make in
            make.height.width.equalTo(MainConstants.Layout.soundButtonSize)
            make.right.equalToSuperview().inset(MainConstants.Layout.soundButtonRightInset)
            make.top.equalToSuperview().inset(MainConstants.Layout.soundButtonTopInset)
        }
        
        let noSoundAction = UIAction { _ in
            self.toggleSound()
        }
        soundButton.addAction(noSoundAction, for: .touchUpInside)
        
        view.addSubview(startGameButton)
        startGameButton.snp.makeConstraints { make in
            make.top.equalTo(MainConstants.Layout.buttonTopOffset)
            make.centerX.equalToSuperview()
            make.height.equalTo(MainConstants.Layout.buttonHeight)
            make.width.equalTo(MainConstants.Layout.buttonWidth)
        }
        let actionStartGame = UIAction { _ in
            self.startGameButtonPressed()
        }
        startGameButton.addAction(actionStartGame, for: .touchUpInside)
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(startGameButton.snp.bottom).offset(MainConstants.Layout.spaceBetweenButtons)
            make.centerX.equalToSuperview()
            make.height.equalTo(MainConstants.Layout.buttonHeight)
            make.width.equalTo(MainConstants.Layout.buttonWidth)
        }
        let actionSettings = UIAction { _ in
            self.settingsButtonPressed()
        }
        settingsButton.addAction(actionSettings, for: .touchUpInside)
        
        view.addSubview(recordsButton)
        recordsButton.snp.makeConstraints { make in
            make.top.equalTo(settingsButton.snp.bottom).offset(MainConstants.Layout.spaceBetweenButtons)
            make.centerX.equalToSuperview()
            make.height.equalTo(MainConstants.Layout.buttonHeight)
            make.width.equalTo(MainConstants.Layout.buttonWidth)
        }
        let actionRecords = UIAction { _ in
            self.recordsButtonPressed()
        }
        recordsButton.addAction(actionRecords, for: .touchUpInside)
    }
    
    // MARK: - Actions
    private func toggleSound() {
        let isEnabled = AudioManager.shared.toggleSound()
        soundButton.isSelected = !isEnabled
        
        UIView.animate(withDuration: MainConstants.Animation.buttonPressDuration) {
            self.soundButton.transform = CGAffineTransform(scaleX: MainConstants.Animation.buttonPressScale,
                                                          y: MainConstants.Animation.buttonPressScale)
        } completion: { _ in
            UIView.animate(withDuration: MainConstants.Animation.buttonPressDuration) {
                self.soundButton.transform = .identity
            }
        }
    }
    
    private func startGameButtonPressed() {
        let controller = GameViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        present(controller, animated: true)
    }
    
    private func settingsButtonPressed() {
        let controller = SettingsViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        present(controller, animated: true)
    }
    
    private func recordsButtonPressed() {
        let controller = RecordsViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        present(controller, animated: true)
    }
}
