import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Consts.cornerRadius
        imageView.image = UIImage(systemName: "figure.skiing.downhill")
        imageView.alpha = 0
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Consts.titleText
        label.font = .boldSystemFont(ofSize: Consts.fontSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Consts.buttonText, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Consts.cornerRadius
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAppearance()
    }

    // MARK: - Private Functions
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(actionButton)
    }

    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Consts.logoTopOffset)
            make.width.height.equalTo(Consts.logoSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(Consts.titleTopOffset)
            make.left.right.equalToSuperview().inset(Consts.horizontalInset)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Consts.buttonTopOffset)
            make.centerX.equalToSuperview()
            make.height.equalTo(Consts.buttonHeight)
            make.width.equalTo(Consts.buttonWidth)
        }
    }
    
    private func setupActions() {
        actionButton.addTarget(self, action: #selector(buttonTouched), for: .touchDown)
    }

    // MARK: - Animations
    
    private func animateAppearance() {
        // Логотип: начальная позиция — выше экрана
        logoImageView.transform = CGAffineTransform(translationX: 0, y: Consts.logoStartOffsetY)
        actionButton.transform = CGAffineTransform(scaleX: Consts.buttonInitialScale, y: Consts.buttonInitialScale)
            .rotated(by: Consts.buttonInitialRotation)
        
        // Логотип: выезд сверху + появление
        UIView.animate(withDuration: Consts.logoAnimationDuration, delay: Consts.logoAnimationDelay, options: [.curveEaseOut]) {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = .identity
        }

        // Заголовок: fade-in через 0.2 секунды
        UIView.animate(withDuration: Consts.titleAnimationDuration, delay: Consts.titleAnimationDelay, options: [.curveEaseIn]) {
            self.titleLabel.alpha = 1
        }

        // Кнопка: масштабирование + поворот с bounce-эффектом через 0.4 секунды и анимацией тени по завершении
        UIView.animate(withDuration: Consts.buttonAnimationDuration,
                       delay: Consts.buttonAnimationDelay,
                       usingSpringWithDamping: Consts.buttonSpringDamping,
                       initialSpringVelocity: Consts.buttonSpringVelocity,
                       options: [.curveLinear]) {
            self.actionButton.transform = .identity
        } completion: { _ in
            self.animateButtonShadow()
        }
    }
    
    // Анимация тени кнопки
    private func animateButtonShadow() {
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.fromValue = 0
        shadowAnimation.toValue = Consts.buttonShadowOpacity
        shadowAnimation.duration = Consts.shadowAnimationDuration
        actionButton.layer.shadowOffset = CGSize(width: 0, height: Consts.shadowOffset)
        actionButton.layer.shadowRadius = Consts.shadowRadius
        actionButton.layer.add(shadowAnimation, forKey: "shadowOpacity")
        actionButton.layer.shadowOpacity = Consts.buttonShadowOpacity
    }
    
    
    // Анимация cornerRadius (при касании кнопки)
    private func animateCornerRadiusChange() {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = Consts.cornerRadius
        animation.toValue = Consts.cornerRadius + Consts.cornerRadiusBounce
        animation.duration = Consts.cornerRadiusAnimationDuration
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        actionButton.layer.add(animation, forKey: "cornerRadius")
        actionButton.layer.cornerRadius = Consts.cornerRadius
    }
    
    @objc private func buttonTouched() {
        animateCornerRadiusChange()
    }
}

// MARK: - ViewController.Consts

extension ViewController {
    private enum Consts {
        // UI
        static let cornerRadius: CGFloat = 16
        static let cornerRadiusBounce: CGFloat = 8
        
        static let fontSize: CGFloat = 22
        
        static let logoSize: CGFloat = 100
        static let logoTopOffset: CGFloat = 40
        static let logoStartOffsetY: CGFloat = -100

        static let titleTopOffset: CGFloat = 20
        static let buttonTopOffset: CGFloat = 30
        static let horizontalInset: CGFloat = 20
        
        static let buttonHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 220
        static let buttonInitialScale: CGFloat = 0.1
        static let buttonInitialRotation: CGFloat = -.pi
        
        // Анимации появления
        static let logoAnimationDuration: TimeInterval = 0.6
        static let logoAnimationDelay: TimeInterval = 0.0
        
        static let titleAnimationDuration: TimeInterval = 0.6
        static let titleAnimationDelay: TimeInterval = 0.2
        
        static let buttonAnimationDuration: TimeInterval = 1.5
        static let buttonAnimationDelay: TimeInterval = 0.4
        static let buttonSpringDamping: CGFloat = 0.5
        static let buttonSpringVelocity: CGFloat = 0.5

        // Тень кнопки
        static let buttonShadowOpacity: Float = 0.5
        static let shadowOffset: CGFloat = 4
        static let shadowRadius: CGFloat = 10
        static let shadowAnimationDuration: TimeInterval = 0.5

        // Анимация радиуса
        static let cornerRadiusAnimationDuration: TimeInterval = 0.3
        
        // Тексты
        static let titleText = "Горнолыжный курорт \"Рога и копыта\""
        static let buttonText = "Забронировать номер"
    }
}
