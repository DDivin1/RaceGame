//
//  SettingsConstants.swift
//  RaceGame
//
//  Created by Dmitry Divin on 09.03.26.
//

import UIKit

enum SettingsConstants {
    
    // MARK: - Layout Constants
    enum Layout {
        static let backButtonLeftOffset: CGFloat = 20
        static let backButtonTopOffset: CGFloat = 60
        static let profilePictureSize: CGFloat = 120
        static let profilePictureLeftInset: CGFloat = 20
        static let profilePictureTopOffset: CGFloat = 100
        static let nameTextFieldLeftOffset: CGFloat = 10
        static let nameTextFieldRightInset: CGFloat = 20
        static let nameTextFieldHeight: CGFloat = 40
        static let carImageTopOffset: CGFloat = 100
        static let carImageWidth: CGFloat = 200
        static let carImageHeight: CGFloat = 200
        static let buttonSize: CGFloat = 60
        static let buttonOffset: CGFloat = 20
        static let obstaclesTopOffset: CGFloat = 40
        static let labelHeight: CGFloat = 40
        static let labelWidth: CGFloat = 200
    }
    
    // MARK: - Font Constants
    enum Font {
        static let nameTextFieldFont = UIFont.systemFont(ofSize: 16)
        static let labelFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    // MARK: - Color Constants
    enum Color {
        static let profilePictureBorder = UIColor.black.cgColor
        static let buttonTint = UIColor.black
        static let labelBackground = UIColor.black.withAlphaComponent(0.3)
        static let labelText = UIColor.white
    }
    
    // MARK: - String Constants
    enum String {
        static let backButtonImage = "chevron.backward"
        static let backgroundImage = "settingsBackgroud"
        static let defaultProfileImage = "defaultPicture"
        static let namePlaceholder = "Enter your name".localized
        static let chooseCarLabel = "Chose your car".localized
        static let chooseObstacleLabel = "Chose obstacle".localized
        static let leftArrowImage = "arrowshape.left.fill"
        static let rightArrowImage = "arrowshape.right.fill"
        static let defaultPlayerName = "Player"
        static let carNames = ["redCar", "yellowCar", "blueCar"]
        static let obstacleNames = ["stone", "trashCan", "cone"]
        static let alertTitle = "Choose Image"
        static let cameraAction = "Camera"
        static let libraryAction = "Library"
        static let cancelAction = "Cancel"
    }
}
