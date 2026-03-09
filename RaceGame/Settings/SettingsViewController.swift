//
//  SettingsViewController.swift
//  RaceGame
//
//  Created by Dmitry Divin on 13.11.25.
//

import UIKit
import SnapKit

// MARK: - SettingsViewController
final class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: SettingsConstants.String.backButtonImage), for: .normal)
        button.tintColor = SettingsConstants.Color.buttonTint
        return button
    }()
    
    private let backPicture: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: SettingsConstants.String.backgroundImage))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = SettingsConstants.Layout.profilePictureSize / 2
        imageView.image = UIImage(named: SettingsConstants.String.defaultProfileImage)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = SettingsConstants.Color.profilePictureBorder
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = SettingsConstants.String.namePlaceholder
        textField.borderStyle = .roundedRect
        textField.font = SettingsConstants.Font.nameTextFieldFont
        textField.autocapitalizationType = .words
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let leftChangeCarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: SettingsConstants.String.leftArrowImage), for: .normal)
        button.tintColor = SettingsConstants.Color.buttonTint
        return button
    }()
    
    private let rightChangeCarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: SettingsConstants.String.rightArrowImage), for: .normal)
        button.tintColor = SettingsConstants.Color.buttonTint
        return button
    }()
    
    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let leftChangeObstaclesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: SettingsConstants.String.leftArrowImage), for: .normal)
        button.tintColor = SettingsConstants.Color.buttonTint
        return button
    }()
    
    private let rightChangeObstaclesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: SettingsConstants.String.rightArrowImage), for: .normal)
        button.tintColor = SettingsConstants.Color.buttonTint
        return button
    }()
    
    private let obstaclesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let choseCarLabel: UILabel = {
        let label = UILabel()
        label.text = SettingsConstants.String.chooseCarLabel
        label.font = SettingsConstants.Font.labelFont
        label.textColor = SettingsConstants.Color.labelText
        label.textAlignment = .center
        label.backgroundColor = SettingsConstants.Color.labelBackground
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    private let choseObstaclesLabel: UILabel = {
        let label = UILabel()
        label.text = SettingsConstants.String.chooseObstacleLabel
        label.font = SettingsConstants.Font.labelFont
        label.textColor = SettingsConstants.Color.labelText
        label.textAlignment = .center
        label.backgroundColor = SettingsConstants.Color.labelBackground
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Properties
    private let carImages: [UIImage] = [
        UIImage(named: SettingsConstants.String.carNames[0])!,
        UIImage(named: SettingsConstants.String.carNames[1])!,
        UIImage(named: SettingsConstants.String.carNames[2])!,
    ]
    
    private let obstaclesImages: [UIImage] = [
        UIImage(named: SettingsConstants.String.obstacleNames[0])!,
        UIImage(named: SettingsConstants.String.obstacleNames[1])!,
        UIImage(named: SettingsConstants.String.obstacleNames[2])!,
    ]
    
    private var pictureIndex = 0
    private let carImagesNames = SettingsConstants.String.carNames
    private let obstaclesImagesNames = SettingsConstants.String.obstacleNames
    private var currentCarIndex = 0
    private var currentObstacleIndex = 0
    private let manager = SaveLoadManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadSettings()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(backPicture)
        backPicture.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SettingsConstants.Layout.backButtonLeftOffset)
            make.top.equalToSuperview().offset(SettingsConstants.Layout.backButtonTopOffset)
        }
        let action = UIAction { _ in
            self.buttonPressed()
        }
        button.addAction(action, for: .touchUpInside)
        
        view.addSubview(profilePicture)
        profilePicture.snp.makeConstraints { make in
            make.height.width.equalTo(SettingsConstants.Layout.profilePictureSize)
            make.left.equalToSuperview().inset(SettingsConstants.Layout.profilePictureLeftInset)
            make.top.equalToSuperview().offset(SettingsConstants.Layout.profilePictureTopOffset)
        }
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.left.equalTo(profilePicture.snp.right).offset(SettingsConstants.Layout.nameTextFieldLeftOffset)
            make.right.equalToSuperview().inset(SettingsConstants.Layout.nameTextFieldRightInset)
            make.height.equalTo(SettingsConstants.Layout.nameTextFieldHeight)
            make.top.equalToSuperview().offset(SettingsConstants.Layout.profilePictureTopOffset)
        }
        
        nameTextField.delegate = self
        
        view.addSubview(carImageView)
        view.addSubview(leftChangeCarButton)
        view.addSubview(rightChangeCarButton)
        
        carImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profilePicture.snp.bottom).offset(SettingsConstants.Layout.carImageTopOffset)
            make.width.equalTo(SettingsConstants.Layout.carImageWidth)
            make.height.equalTo(SettingsConstants.Layout.carImageHeight)
        }
        carImageView.image = carImages[0]
        
        leftChangeCarButton.snp.makeConstraints { make in
            make.width.height.equalTo(SettingsConstants.Layout.buttonSize)
            make.centerY.equalTo(carImageView)
            make.right.equalTo(carImageView.snp.left).offset(-SettingsConstants.Layout.buttonOffset)
        }
        let leftCarChangeAction = UIAction { _ in
            self.leftChangeCarButtonPressed()
        }
        leftChangeCarButton.addAction(leftCarChangeAction, for: .touchUpInside)
        
        rightChangeCarButton.snp.makeConstraints { make in
            make.width.height.equalTo(SettingsConstants.Layout.buttonSize)
            make.centerY.equalTo(carImageView)
            make.left.equalTo(carImageView.snp.right).offset(SettingsConstants.Layout.buttonOffset)
        }
        let rightCarChangeAction = UIAction { _ in
            self.rightChangeCarButtonPressed()
        }
        rightChangeCarButton.addAction(rightCarChangeAction, for: .touchUpInside)
        
        view.addSubview(obstaclesImageView)
        view.addSubview(leftChangeObstaclesButton)
        view.addSubview(rightChangeObstaclesButton)
        
        obstaclesImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(carImageView.snp.bottom).offset(SettingsConstants.Layout.obstaclesTopOffset)
            make.width.equalTo(SettingsConstants.Layout.carImageWidth)
            make.height.equalTo(SettingsConstants.Layout.carImageHeight)
        }
        
        leftChangeObstaclesButton.snp.makeConstraints { make in
            make.width.height.equalTo(SettingsConstants.Layout.buttonSize)
            make.centerY.equalTo(obstaclesImageView)
            make.right.equalTo(obstaclesImageView.snp.left).offset(-SettingsConstants.Layout.buttonOffset)
        }
        let leftObstaclesChangeAction = UIAction { _ in
            self.leftChangeObstaclesButtonPressed()
        }
        leftChangeObstaclesButton.addAction(leftObstaclesChangeAction, for: .touchUpInside)
        
        rightChangeObstaclesButton.snp.makeConstraints { make in
            make.width.height.equalTo(SettingsConstants.Layout.buttonSize)
            make.centerY.equalTo(obstaclesImageView)
            make.left.equalTo(obstaclesImageView.snp.right).offset(SettingsConstants.Layout.buttonOffset)
        }
        let rightObstaclesChangeAction = UIAction { _ in
            self.rightChangeObstaclesButtonPressed()
        }
        rightChangeObstaclesButton.addAction(rightObstaclesChangeAction, for: .touchUpInside)
        
        setUpGesture()
        loadSavedName()
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        view.addSubview(choseCarLabel)
        choseCarLabel.snp.makeConstraints { make in
            make.height.equalTo(SettingsConstants.Layout.labelHeight)
            make.width.equalTo(SettingsConstants.Layout.labelWidth)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(carImageView.snp.top)
        }
        
        view.addSubview(choseObstaclesLabel)
        choseObstaclesLabel.snp.makeConstraints { make in
            make.height.equalTo(SettingsConstants.Layout.labelHeight)
            make.width.equalTo(SettingsConstants.Layout.labelWidth)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(obstaclesImageView.snp.top)
        }
    }
    
    // MARK: - Actions
    private func buttonPressed() {
        let settings = manager.loadSettings() ?? PlayerSettings()
        settings.name = nameTextField.text ?? SettingsConstants.String.defaultPlayerName
        settings.carName = carImagesNames[currentCarIndex]
        settings.obstacleName = obstaclesImagesNames[currentObstacleIndex]
        if settings.avatarPictureName == nil {
            if let defaultImage = UIImage(named: SettingsConstants.String.defaultProfileImage),
               let fileName = manager.saveImage(image: defaultImage) {
                settings.avatarPictureName = fileName
            }
        }
        manager.saveSettings(settings)
        dismiss(animated: true)
    }
    
    private func loadSettings() {
        if let settings = manager.loadSettings() {
            nameTextField.text = settings.name
            if let avatarFileName = settings.avatarPictureName,
               let avatarImage = manager.loadImage(filename: avatarFileName) {
                profilePicture.image = avatarImage
            }
            if let obstacleIndex = obstaclesImagesNames.firstIndex(of: settings.obstacleName) {
                currentObstacleIndex = obstacleIndex
                obstaclesImageView.image = obstaclesImages[currentObstacleIndex]
            } else {
                currentObstacleIndex = 0
                obstaclesImageView.image = obstaclesImages[currentObstacleIndex]
            }
            
            if let carIndex = carImagesNames.firstIndex(of: settings.carName) {
                currentCarIndex = carIndex
                carImageView.image = carImages[currentCarIndex]
            } else {
                nameTextField.text = SettingsConstants.String.defaultPlayerName
                carImageView.image = carImages[0]
                obstaclesImageView.image = obstaclesImages[0]
            }
        } else {
            carImageView.image = carImages[currentCarIndex]
            obstaclesImageView.image = obstaclesImages[currentObstacleIndex]
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        
        if let text = nameTextField.text, !text.isEmpty {
            manager.saveName(text)
        }
    }
    
    @objc func setUpGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textFieldDidChange() {
        if let text = nameTextField.text {
            manager.saveName(text)
        }
    }
    
    private func loadSavedName() {
        if let savedName = manager.loadName() {
            nameTextField.text = savedName
        } else {
            nameTextField.text = SettingsConstants.String.defaultPlayerName
        }
    }
    
    private func leftChangeCarButtonPressed() {
        currentCarIndex = (currentCarIndex - 1 + carImages.count) % carImages.count
        carImageView.image = carImages[currentCarIndex]
    }
    
    private func rightChangeCarButtonPressed() {
        currentCarIndex = (currentCarIndex + 1) % carImages.count
        carImageView.image = carImages[currentCarIndex]
    }
    
    private func leftChangeObstaclesButtonPressed() {
        currentObstacleIndex = (currentObstacleIndex - 1 + obstaclesImages.count) % obstaclesImages.count
        obstaclesImageView.image = obstaclesImages[currentObstacleIndex]
    }
    
    private func rightChangeObstaclesButtonPressed() {
        currentObstacleIndex = (currentObstacleIndex + 1) % obstaclesImages.count
        obstaclesImageView.image = obstaclesImages[currentObstacleIndex]
    }
    
    @objc func imageTapped() {
        showImagePickerAlert()
    }
    
    private func showImagePickerAlert() {
        let alert = UIAlertController(
            title: SettingsConstants.String.alertTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cameraAction = UIAlertAction(title: SettingsConstants.String.cameraAction, style: .default) { [weak self] _ in
            self?.showPicker(.camera)
        }
        alert.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: SettingsConstants.String.libraryAction, style: .default) { [weak self] _ in
            self?.showPicker(.photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: SettingsConstants.String.cancelAction, style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showPicker(_ sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        if let fileName = manager.saveImage(image: image) {
            var settings = manager.loadSettings() ?? PlayerSettings()
            settings.avatarPictureName = fileName
            manager.saveSettings(settings)
        }
        self.profilePicture.image = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
