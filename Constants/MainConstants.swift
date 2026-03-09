//
//  MainConstants.swift
//  RaceGame
//
//  Created by Dmitry Divin on 09.03.26.
//

import UIKit

enum MainConstants {
    
    // MARK: - Layout Constants
    enum Layout {
        static let buttonOffset: CGFloat = 15
        static let buttonHeight: CGFloat = 60
        static let buttonWidth: CGFloat = 250
        static let spaceBetweenButtons: CGFloat = 20
        static let buttonTopOffset: CGFloat = 250
        static let soundButtonSize: CGFloat = 32
        static let soundButtonRightInset: CGFloat = 32
        static let soundButtonTopInset: CGFloat = 64
    }
    
    // MARK: - Font Constants
    enum Font {
        static let buttonFontSize: CGFloat = 20
    }
    
    // MARK: - Color Constants
    enum Color {
        static let buttonBackground: UIColor = .systemRed
        static let buttonTitle: UIColor = .white
        static let soundButtonTint: UIColor = .white
    }
    
    // MARK: - Animation Constants
    enum Animation {
        static let buttonPressScale: CGFloat = 0.8
        static let buttonPressDuration: TimeInterval = 0.1
        static let shadowRadius: CGFloat = 5
        static let buttonCornerRadius: CGFloat = 5
    }
    
    // MARK: - String Constants
    enum String {
        static let mainBackground = "mainPicture"
        static let soundOnImage = "speaker.wave.3"
        static let soundOffImage = "speaker.slash"
        static let startGame = "Start Game".localized
        static let settings = "Settings".localized
        static let records = "Records".localized
    }
}
