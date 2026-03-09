//
//  RecordsViewController.swift
//  RaceGame
//
//  Created by Dmitry Divin on 13.11.25.
//

import UIKit
import SnapKit

// MARK: - RecordsViewController
final class RecordsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: RecordsConstants.String.backButtonImage), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: SettingsConstants.String.backgroundImage))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = RecordsConstants.String.title
        label.font = RecordsConstants.Font.titleFont
        label.textColor = RecordsConstants.Color.titleText
        label.textAlignment = .center
        label.backgroundColor = RecordsConstants.Color.titleBackground
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = RecordsConstants.String.emptyState
        label.font = RecordsConstants.Font.emptyStateFont
        label.textColor = RecordsConstants.Color.emptyStateText
        label.textAlignment = .center
        label.backgroundColor = RecordsConstants.Color.emptyStateBackground
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    private lazy var recordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecordsViewCell.self, forCellReuseIdentifier: RecordsViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(
            top: RecordsConstants.Layout.tableViewInset,
            left: 0,
            bottom: RecordsConstants.Layout.tableViewInset * 2.5,
            right: 0
        )
        return tableView
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.alpha = RecordsConstants.Color.blurAlpha
        return view
    }()
    
    // MARK: - Properties
    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = RecordsConstants.String.dateFormat
        return formatter
    }()
    
    private let manager = SaveLoadManager()
    private var records: [RaceRecords] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadRecord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecord()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(RecordsConstants.Layout.backButtonLeftOffset)
            make.top.equalToSuperview().offset(RecordsConstants.Layout.backButtonTopOffset)
            make.width.height.equalTo(RecordsConstants.Layout.backButtonSize)
        }
        
        let action = UIAction { _ in
            self.buttonPressed()
        }
        button.addAction(action, for: .touchUpInside)
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(RecordsConstants.Layout.titleLabelTopOffset)
            make.width.equalTo(RecordsConstants.Layout.titleLabelWidth)
            make.height.equalTo(RecordsConstants.Layout.titleLabelHeight)
        }
        
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(RecordsConstants.Layout.blurViewTopOffset)
            make.left.right.equalToSuperview().inset(RecordsConstants.Layout.blurViewHorizontalInset)
            make.bottom.equalToSuperview().offset(-RecordsConstants.Layout.blurViewBottomOffset)
        }
        
        blurView.contentView.addSubview(recordsTableView)
        recordsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(RecordsConstants.Layout.tableViewInset)
        }
        
        view.addSubview(emptyStateLabel)
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalTo(blurView)
            make.left.right.equalTo(blurView).inset(RecordsConstants.Layout.emptyStateHorizontalInset)
            make.height.equalTo(RecordsConstants.Layout.emptyStateHeight)
        }
    }
    
    // MARK: - Actions
    private func buttonPressed() {
        dismiss(animated: true)
    }
    
    private func loadRecord() {
        records = manager.loadAllRecords().sorted { $0.record > $1.record }
        recordsTableView.reloadData()
        
        emptyStateLabel.isHidden = !records.isEmpty
        recordsTableView.isHidden = records.isEmpty
    }
}

// MARK: - TableView DataSource & Delegate
extension RecordsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecordsViewCell.identifier,
            for: indexPath
        ) as? RecordsViewCell else {
            return UITableViewCell()
        }
        
        let record = records[indexPath.row]
        let formattedDate = formatter.string(from: record.date)
        
        let textColor: UIColor
        let font: UIFont
        
        switch indexPath.row {
        case 0:
            textColor = RecordsConstants.Color.firstPlaceText
            font = RecordsConstants.Font.firstPlaceFont
        case 1:
            textColor = RecordsConstants.Color.secondPlaceText
            font = RecordsConstants.Font.secondPlaceFont
        case 2:
            textColor = RecordsConstants.Color.thirdPlaceText
            font = RecordsConstants.Font.thirdPlaceFont
        default:
            textColor = RecordsConstants.Color.defaultText
            font = RecordsConstants.Font.defaultFont
        }
        
        let medal = indexPath.row < 3 ? RecordsConstants.String.medals[indexPath.row] : ""
        let pointsText = RecordsConstants.String.points
        let text = "\(medal) \(indexPath.row + 1). \(record.playerName): \(record.record) \(pointsText)\(RecordsConstants.String.separator)\(formattedDate)"
        
        cell.configure(with: text, textColor: textColor, font: font)
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: RecordsConstants.Layout.animationOffset, y: 0)
        
        UIView.animate(
            withDuration: RecordsConstants.Layout.animationDuration,
            delay: Double(indexPath.row) * RecordsConstants.Layout.animationDelay,
            options: .curveEaseOut
        ) {
            cell.alpha = 1
            cell.transform = .identity
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecordsConstants.Layout.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let headerLabel = UILabel()
        headerLabel.text = RecordsConstants.String.topResults
        headerLabel.font = RecordsConstants.Font.headerFont
        headerLabel.textColor = RecordsConstants.Color.headerText
        headerLabel.textAlignment = .center
        headerLabel.backgroundColor = RecordsConstants.Color.headerBackground
        headerLabel.layer.cornerRadius = 10
        headerLabel.clipsToBounds = true
        
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(RecordsConstants.Layout.headerWidth)
            make.height.equalTo(RecordsConstants.Layout.headerLabelHeight)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return records.isEmpty ? 0 : RecordsConstants.Layout.headerHeight
    }
}
