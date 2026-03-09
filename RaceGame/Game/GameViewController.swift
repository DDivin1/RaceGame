//
//  GameViewController.swift
//  RaceGame
//
//  Created by Dmitry Divin on 13.11.25.
//

import UIKit
import SnapKit

// MARK: - GameViewController
final class GameViewController: UIViewController {
    
    // MARK: - UI Elements
    private let leftRoadSideImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let rightRoadSideImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: GameConstants.String.backButtonImage), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let roadView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let secondRoadView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.backgroundColor = GameConstants.Color.scoreLabelBackground
        label.textColor = GameConstants.Color.scoreLabelText
        label.layer.borderWidth = 1
        label.layer.borderColor = GameConstants.Color.scoreLabelBorder
        label.clipsToBounds = true
        return label
    }()
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = GameConstants.String.scoreText
        label.textColor = GameConstants.Color.scoreLabelText
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private let carView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("<-", for: .normal)
        button.setTitleColor(GameConstants.Color.buttonTitle, for: .normal)
        button.backgroundColor = GameConstants.Color.buttonBackground
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = GameConstants.Color.buttonBorder
        button.clipsToBounds = true
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("->", for: .normal)
        button.setTitleColor(GameConstants.Color.buttonTitle, for: .normal)
        button.backgroundColor = GameConstants.Color.buttonBackground
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = GameConstants.Color.buttonBorder
        button.clipsToBounds = true
        return button
    }()
    
    private let countDownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: GameConstants.Font.countdownFontName, size: GameConstants.Font.countdownFontSize)
        label.textColor = GameConstants.Color.countdownText
        label.backgroundColor = GameConstants.Color.countdownBackground
        label.clipsToBounds = true
        return label
    }()
    
    private var explodeView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Game Properties
    private var displayLink: CADisplayLink?
    private var roadY1: CGFloat = 0
    private var roadY2: CGFloat = 0
    private var isGamePaused = false
    
    private var scoreTimer = Timer()
    private var obstacleTimer = Timer()
    private var currentScore: Int = 0
    private var hightScore: Int = 0
    private let manager = SaveLoadManager()
    private var obstacles: [UIImageView] = []
    private var obstacleImageName: String = GameConstants.Obstacle.defaultName
    private var isGameActive = false
    private var collisionTimer: Timer?
    private var roadAnimationSpeed: CGFloat = GameConstants.Animation.roadSpeed
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        showCountDownLabel()
        setUpCar()
        setUpObstacleSettings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.leftButton.dropShadow()
        self.rightButton.dropShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAllAnimations()
        stopAllTimers()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .white
        
        let roadWidth = view.frame.width - 2 * GameConstants.Layout.roadOffset
        
        view.addSubview(roadView)
        roadView.image = UIImage(named: GameConstants.String.roadImage)
        roadView.frame = CGRect(
            x: GameConstants.Layout.roadOffset,
            y: roadY1,
            width: roadWidth,
            height: view.frame.height
        )
        
        view.addSubview(secondRoadView)
        secondRoadView.image = UIImage(named: GameConstants.String.roadImage)
        secondRoadView.frame = CGRect(
            x: GameConstants.Layout.roadOffset,
            y: roadY2,
            width: roadWidth,
            height: view.frame.height
        )
        
        view.addSubview(leftRoadSideImage)
        leftRoadSideImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(roadView.snp.left)
            leftRoadSideImage.image = UIImage(named: GameConstants.String.grassImage)
        }
        
        view.addSubview(rightRoadSideImage)
        rightRoadSideImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(roadView.snp.right)
            rightRoadSideImage.image = UIImage(named: GameConstants.String.grassImage)
        }
        
        view.addSubview(carView)
        carView.snp.makeConstraints { make in
            make.width.equalTo(GameConstants.Layout.carWidth)
            make.height.equalTo(GameConstants.Layout.carHeight)
            make.centerX.equalTo(roadView)
            make.bottom.equalToSuperview().inset(GameConstants.Layout.carBottomInset)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GameConstants.Layout.backButtonLeftOffset)
            make.top.equalToSuperview().offset(GameConstants.Layout.backButtonTopOffset)
        }
        let action = UIAction { _ in
            self.buttonPressed()
        }
        button.addAction(action, for: .touchUpInside)
        
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.height.equalTo(GameConstants.Layout.scoreLabelHeight)
            make.width.equalTo(GameConstants.Layout.scoreLabelWidth)
            make.right.equalToSuperview().inset(GameConstants.Layout.buttonsOffset)
            make.top.equalToSuperview().offset(GameConstants.Layout.backButtonTopOffset)
        }
        
        view.addSubview(labelName)
        labelName.snp.makeConstraints { make in
            make.bottom.equalTo(scoreLabel.snp.top)
            make.height.equalTo(GameConstants.Layout.labelNameHeight)
            make.width.equalTo(scoreLabel)
            make.centerX.equalTo(scoreLabel)
        }
        
        view.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(GameConstants.Layout.bottomInset)
            make.left.equalToSuperview().offset(GameConstants.Layout.buttonsOffset)
            make.height.equalTo(GameConstants.Layout.moveButtonsHeight)
            make.width.equalTo(GameConstants.Layout.moveButtonWidth)
        }
        let leftAction = UIAction { _ in
            self.leftButtonPressed()
        }
        leftButton.addAction(leftAction, for: .touchUpInside)
        
        view.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(GameConstants.Layout.bottomInset)
            make.right.equalToSuperview().inset(GameConstants.Layout.buttonsOffset)
            make.height.equalTo(GameConstants.Layout.moveButtonsHeight)
            make.width.equalTo(GameConstants.Layout.moveButtonWidth)
        }
        let rightAction = UIAction { _ in
            self.rightButtonPressed()
        }
        rightButton.addAction(rightAction, for: .touchUpInside)
    }
    
    // MARK: - Road Animation
    private func startRoadAnimation() {
        displayLink?.invalidate()
        
        roadY1 = 0
        roadY2 = -view.frame.height
        updateRoadPositions()
        
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidFire))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    @objc private func displayLinkDidFire(_ displayLink: CADisplayLink) {
        guard !isGamePaused, isGameActive else { return }
        
        roadY1 += roadAnimationSpeed
        roadY2 += roadAnimationSpeed
        
        if roadY1 >= view.frame.height {
            roadY1 = roadY2 - view.frame.height
        }
        if roadY2 >= view.frame.height {
            roadY2 = roadY1 - view.frame.height
        }
        
        updateRoadPositions()
        
        for obstacle in obstacles {
            obstacle.frame.origin.y += roadAnimationSpeed
            
            if obstacle.frame.origin.y >= view.frame.height {
                obstacle.removeFromSuperview()
                if let index = obstacles.firstIndex(of: obstacle) {
                    obstacles.remove(at: index)
                }
            }
        }
    }
    
    private func updateRoadPositions() {
        roadView.frame.origin.y = roadY1
        secondRoadView.frame.origin.y = roadY2
    }
    
    // MARK: - Animation Control
    private func stopAllAnimations() {
        displayLink?.invalidate()
        displayLink = nil
        
        roadView.layer.removeAllAnimations()
        secondRoadView.layer.removeAllAnimations()
        
        for obstacle in obstacles {
            obstacle.layer.removeAllAnimations()
        }
        
        carView.layer.removeAllAnimations()
    }
    
    // MARK: - Game Control
    private func buttonPressed() {
        stopAllAnimations()
        stopAllTimers()
        dismiss(animated: true)
    }
    
    private func leftButtonPressed() {
        guard isGameActive else { return }
        
        let currentCenterX = carView.center.x
        let roadFrame = roadView.frame
        let newCenterX = currentCenterX - GameConstants.Layout.carMoveStep
        
        carView.snp.updateConstraints { make in
            make.centerX.equalTo(roadView).offset(newCenterX - roadFrame.midX)
        }
        
        UIView.animate(withDuration: GameConstants.Animation.carMoveDuration) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            if self.carView.frame.origin.x < roadFrame.origin.x - GameConstants.Layout.carMoveStep {
                let collisionPoint = CGPoint(
                    x: self.carView.frame.minX,
                    y: self.carView.center.y
                )
                self.showExplode(at: collisionPoint)
                AudioManager.shared.stopBackgroundMusic()
                AudioManager.shared.playCrashSound()
                self.showGameOverAlert(reason: GameConstants.String.offRoadReason)
            } else {
                self.checkCollisions()
            }
        }
    }

    private func rightButtonPressed() {
        guard isGameActive else { return }
        
        let currentCenterX = carView.center.x
        let roadFrame = roadView.frame
        let newCenterX = currentCenterX + GameConstants.Layout.carMoveStep
        
        carView.snp.updateConstraints { make in
            make.centerX.equalTo(roadView).offset(newCenterX - roadFrame.midX)
        }
        
        UIView.animate(withDuration: GameConstants.Animation.carMoveDuration) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            if self.carView.frame.origin.x + self.carView.frame.width > roadFrame.origin.x + roadFrame.width + GameConstants.Layout.carMoveStep {
                let collisionPoint = CGPoint(
                    x: self.carView.frame.maxX,
                    y: self.carView.center.y
                )
                self.showExplode(at: collisionPoint)
                AudioManager.shared.stopBackgroundMusic()
                AudioManager.shared.playCrashSound()
                self.showGameOverAlert(reason: GameConstants.String.offRoadReason)
            } else {
                self.checkCollisions()
            }
        }
    }
    
    // MARK: - Countdown
    private func showCountDownLabel() {
        view.addSubview(countDownLabel)
        countDownLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
        var count = GameConstants.Timer.countdownStart
        countDownLabel.text = "\(count)"
        
        Timer.scheduledTimer(withTimeInterval: GameConstants.Timer.countdownInterval, repeats: true) { [weak self] timer in
            count -= 1
            
            if count > 0 {
                self?.countDownLabel.text = "\(count)"
            } else if count == 0 {
                self?.countDownLabel.text = GameConstants.String.goText
            } else {
                timer.invalidate()
                self?.countDownLabel.removeFromSuperview()
                self?.startGame()
            }
        }
    }
    
    private func startGame() {
        isGameActive = true
        isGamePaused = false
        startRoadAnimation()
        startScoreTimer()
        startObstacleSpawnTimer()
        startCollisionDetectionTimer()
    }
    
    // MARK: - Car Setup
    private func setUpCar() {
        if let settings = manager.loadSettings() {
            carView.image = UIImage(named: settings.carName)
        } else {
            carView.image = UIImage(named: GameConstants.String.defaultCar)
        }
    }
    
    // MARK: - Collision Detection
    private func startCollisionDetectionTimer() {
        collisionTimer?.invalidate()
        collisionTimer = Timer.scheduledTimer(withTimeInterval: GameConstants.Timer.collisionCheckInterval, repeats: true) { [weak self] _ in
            self?.checkCollisions()
        }
    }
    
    private func checkCollisions() {
        guard isGameActive else { return }
        
        let carFrame = carView.frame
        
        for obstacle in obstacles {
            let obstacleFrame = obstacle.frame
            
            if carFrame.intersects(obstacleFrame) {
                let intersectionRect = carFrame.intersection(obstacleFrame)
                let collisionPoint = CGPoint(
                    x: intersectionRect.midX,
                    y: intersectionRect.midY
                )
                
                AudioManager.shared.playCrashSound()
                AudioManager.shared.stopBackgroundMusic()
                showExplode(at: collisionPoint)
                showGameOverAlert(reason: GameConstants.String.collisionReason)
                return
            }
        }
    }
    
    // MARK: - Obstacle System
    private func setUpObstacleSettings() {
        if let settings = manager.loadSettings() {
            obstacleImageName = settings.obstacleName
        } else {
            obstacleImageName = GameConstants.Obstacle.defaultName
        }
    }
    
    private func startObstacleSpawnTimer() {
        obstacleTimer = Timer.scheduledTimer(withTimeInterval: GameConstants.Timer.obstacleSpawnInterval,
                                           repeats: true) { [weak self] _ in
            self?.spawnObstacle()
        }
    }
    
    private func spawnObstacle() {
        guard isGameActive else { return }
        
        let randomX = CGFloat.random(
            in: roadView.frame.minX...(roadView.frame.maxX - GameConstants.Obstacle.width)
        )
        
        let obstacle = UIImageView()
        obstacle.image = UIImage(named: obstacleImageName)
        obstacle.contentMode = .scaleAspectFit
        obstacle.frame = CGRect(
            x: randomX,
            y: -GameConstants.Obstacle.height,
            width: GameConstants.Obstacle.width,
            height: GameConstants.Obstacle.height
        )
        
        view.insertSubview(obstacle, belowSubview: carView)
        obstacles.append(obstacle)
    }
    
    private func showExplode(at point: CGPoint) {
        let explodeView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: GameConstants.Layout.explodeViewSize,
            height: GameConstants.Layout.explodeViewSize
        ))
        explodeView.center = point
        explodeView.contentMode = .scaleAspectFit
        explodeView.image = UIImage(named: GameConstants.String.boomImage)
        explodeView.alpha = 0.0
        
        view.addSubview(explodeView)
        
        UIView.animate(withDuration: GameConstants.Animation.explodeDuration) {
            explodeView.transform = CGAffineTransform(scaleX: GameConstants.Animation.explodeScale,
                                                     y: GameConstants.Animation.explodeScale)
            explodeView.alpha = 1.0
        }
    }
    
    // MARK: - Score System
    private func startScoreTimer() {
        scoreTimer.invalidate()
        currentScore = 0
        scoreLabel.text = "\(currentScore)"
        scoreTimer = Timer.scheduledTimer(withTimeInterval: GameConstants.Timer.scoreUpdateInterval,
                                         repeats: true) { [weak self] timer in
            self?.currentScore += 1
            self?.updateScoreLabel()
        }
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "\(currentScore)"
    }
    
    // MARK: - Game Over
    private func showGameOverAlert(reason: String) {
        isGameActive = false
        isGamePaused = true
        
        stopAllAnimations()
        stopAllTimers()
        saveCurrentRecord()
        
        let alert = UIAlertController(
            title: GameConstants.String.gameOverTitle,
            message: "\(reason) \nYour result: \(currentScore)".localized,
            preferredStyle: .alert
        )
        
        let restartAction = UIAlertAction(title: GameConstants.String.startAgain, style: .default) { [weak self] _ in
            self?.restartGame()
        }
        let exitAction = UIAlertAction(title: GameConstants.String.exit, style: .default) { [weak self] _ in
            if AudioManager.shared.isSoundEnabled() {
                AudioManager.shared.startBackgroundMusic()
            }
            self?.dismiss(animated: true)
        }
        alert.addAction(restartAction)
        alert.addAction(exitAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Restart Game
    private func restartGame() {
        stopAllAnimations()
        stopAllTimers()
        
        if AudioManager.shared.isSoundEnabled() {
            AudioManager.shared.startBackgroundMusic()
        }

        for subview in view.subviews {
            if let imageView = subview as? UIImageView,
               imageView.image == UIImage(named: GameConstants.String.boomImage) {
                imageView.removeFromSuperview()
            }
        }
        
        for obstacle in obstacles {
            obstacle.removeFromSuperview()
        }
        obstacles.removeAll()
        
        roadY1 = 0
        roadY2 = -view.frame.height
        updateRoadPositions()
        
        carView.snp.updateConstraints { make in
            make.centerX.equalTo(roadView)
        }
        
        currentScore = 0
        scoreLabel.text = "\(currentScore)"
        
        self.view.layoutIfNeeded()
        showCountDownLabel()
    }
    
    // MARK: - Save Records
    private func saveCurrentRecord() {
        let playerName: String
        if let settings = manager.loadSettings() {
            playerName = settings.name
        } else {
            playerName = GameConstants.String.defaultPlayerName
        }
        let record = RaceRecords(playerName: playerName, record: currentScore, date: Date())
        manager.saveRecords(record)
    }
    
    // MARK: - Stop All Timers
    private func stopAllTimers() {
        scoreTimer.invalidate()
        obstacleTimer.invalidate()
        collisionTimer?.invalidate()
        isGameActive = false
        isGamePaused = true
    }
}
