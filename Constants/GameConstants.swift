//
//  GameConstants.swift
//  RaceGame
//
//  Created by Dmitry Divin on 09.03.26.
//

import UIKit

enum GameConstants {
    
    // MARK: - Layout Constants
    enum Layout {
        static let moveButtonsHeight: CGFloat = 60
        static let moveButtonWidth: CGFloat = 120
        static let bottomInset: CGFloat = 24
        static let buttonsOffset: CGFloat = 20
        static let roadOffset: CGFloat = 48
        static let carWidth: CGFloat = 80
        static let carHeight: CGFloat = 120
        static let carBottomInset: CGFloat = 85
        static let backButtonLeftOffset: CGFloat = 20
        static let backButtonTopOffset: CGFloat = 60
        static let scoreLabelHeight: CGFloat = 40
        static let scoreLabelWidth: CGFloat = 120
        static let labelNameHeight: CGFloat = 24
        static let carMoveStep: CGFloat = 30
        static let explodeViewSize: CGFloat = 80
    }
    
    // MARK: - Animation Constants
    enum Animation {
        static let roadSpeed: CGFloat = 5.0
        static let carMoveDuration: TimeInterval = 0.2
        static let explodeDuration: TimeInterval = 0.3
        static let explodeScale: CGFloat = 1.5
        static let buttonPressScale: CGFloat = 0.8
        static let buttonPressDuration: TimeInterval = 0.1
    }
    
    // MARK: - Timer Constants
    enum Timer {
        static let obstacleSpawnInterval: TimeInterval = 1.5
        static let scoreUpdateInterval: TimeInterval = 0.1
        static let collisionCheckInterval: TimeInterval = 0.05
        static let countdownInterval: TimeInterval = 1.0
        static let countdownStart: Int = 3
    }
    
    // MARK: - Obstacle Constants
    enum Obstacle {
        static let width: CGFloat = 60
        static let height: CGFloat = 60
        static let defaultName = "cone"
    }
    
    // MARK: - Font Constants
    enum Font {
        static let countdownFontSize: CGFloat = 150
        static let countdownFontName = "Konstant"
    }
    
    // MARK: - Color Constants
    enum Color {
        static let scoreLabelBackground = UIColor.black.withAlphaComponent(0.5)
        static let scoreLabelBorder = UIColor.black.cgColor
        static let scoreLabelText = UIColor.black
        static let buttonBackground = UIColor.black.withAlphaComponent(0.5)
        static let buttonBorder = UIColor.yellow.cgColor
        static let buttonTitle = UIColor.yellow
        static let countdownText = UIColor.systemOrange
        static let countdownBackground = UIColor.black.withAlphaComponent(0.5)
    }
    
    // MARK: - String Constants
    enum String {
        static let scoreText = "SCORE".localized
        static let goText = "GO!".localized
        static let offRoadReason = "You went off the road!".localized
        static let collisionReason = "Collision with a obstacle!".localized
        static let gameOverTitle = "Game over!".localized
        static let startAgain = "Start again".localized
        static let exit = "Exit".localized
        static let defaultPlayerName = "Player"
        static let roadImage = "road"
        static let grassImage = "grass"
        static let defaultCar = "redCar"
        static let boomImage = "boom"
        static let backButtonImage = "chevron.backward"
    }
}
