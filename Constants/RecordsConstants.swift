//
//  RecordsConstants.swift
//  RaceGame
//
//  Created by Dmitry Divin on 09.03.26.
//

import UIKit

enum RecordsConstants {
    
    // MARK: - Layout Constants
    enum Layout {
        static let backButtonLeftOffset: CGFloat = 20
        static let backButtonTopOffset: CGFloat = 60
        static let backButtonSize: CGFloat = 44
        static let titleLabelWidth: CGFloat = 200
        static let titleLabelHeight: CGFloat = 50
        static let titleLabelTopOffset: CGFloat = 10
        static let blurViewHorizontalInset: CGFloat = 16
        static let blurViewBottomOffset: CGFloat = 40
        static let blurViewTopOffset: CGFloat = 20
        static let tableViewInset: CGFloat = 8
        static let emptyStateHeight: CGFloat = 100
        static let emptyStateHorizontalInset: CGFloat = 20
        static let cellHeight: CGFloat = 60
        static let headerHeight: CGFloat = 40
        static let headerWidth: CGFloat = 200
        static let headerLabelHeight: CGFloat = 30
        static let animationOffset: CGFloat = 20
        static let animationDelay: TimeInterval = 0.05
        static let animationDuration: TimeInterval = 0.3
    }
    
    // MARK: - Font Constants
    enum Font {
        static let titleFont = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let emptyStateFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        static let headerFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        static let firstPlaceFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        static let secondPlaceFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let thirdPlaceFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let defaultFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    // MARK: - Color Constants
    enum Color {
        static let titleBackground = UIColor.black.withAlphaComponent(0.3)
        static let titleText = UIColor.white
        static let emptyStateBackground = UIColor.white.withAlphaComponent(0.8)
        static let emptyStateText = UIColor.darkGray
        static let headerBackground = UIColor.white.withAlphaComponent(0.5)
        static let headerText = UIColor.darkGray
        static let firstPlaceText = UIColor.systemYellow
        static let secondPlaceText = UIColor.systemGray
        static let thirdPlaceText = UIColor.systemBrown
        static let defaultText = UIColor.darkGray
        static let blurAlpha: CGFloat = 0.9
    }
    
    // MARK: - String Constants
    enum String {
        static let title = "Records".localized
        static let emptyState = "No saved records yet".localized
        static let points = "points".localized
        static let topResults = "Top results".localized
        static let backButtonImage = "chevron.backward"
        static let dateFormat = "dd.MM.yyyy"
        static let medals = ["🥇", "🥈", "🥉"]
        static let separator = " • "
    }
}
