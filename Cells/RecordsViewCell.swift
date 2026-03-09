//
//  RecordsViewCell.swift
//  RaceGame
//
//  Created by Dmitry Divin on 12.01.26.
//

import SnapKit
import UIKit

// MARK: - Constants
private enum Constants {
    static let containerCornerRadius: CGFloat = 12
    static let containerShadowOpacity: Float = 0.1
    static let containerShadowOffset = CGSize(width: 0, height: 1)
    static let containerShadowRadius: CGFloat = 2
    static let containerTopInset: CGFloat = 4
    static let containerLeftInset: CGFloat = 8
    static let containerBottomInset: CGFloat = 4
    static let containerRightInset: CGFloat = 8
    static let labelLeftOffset: CGFloat = 12
    static let labelRightOffset: CGFloat = -12
    static let defaultFontSize: CGFloat = 15
}

// MARK: - RecordsViewCell
final class RecordsViewCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier: String { "\(Self.self)" }
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.layer.cornerRadius = Constants.containerCornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = Constants.containerShadowOpacity
        view.layer.shadowOffset = Constants.containerShadowOffset
        view.layer.shadowRadius = Constants.containerShadowRadius
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(label)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(
                top: Constants.containerTopInset,
                left: Constants.containerLeftInset,
                bottom: Constants.containerBottomInset,
                right: Constants.containerRightInset
            ))
        }
        
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.labelLeftOffset)
            make.right.equalToSuperview().offset(Constants.labelRightOffset)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func configure(with text: String, textColor: UIColor = .darkGray, font: UIFont = .systemFont(ofSize: Constants.defaultFontSize)) {
        label.text = text
        label.textColor = textColor
        label.font = font
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: Constants.defaultFontSize)
    }
}
