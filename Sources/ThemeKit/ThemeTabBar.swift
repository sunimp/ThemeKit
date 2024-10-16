//
//  ThemeTabBar.swift
//  ThemeKit
//
//  Created by Sun on 2024/8/23.
//

import UIKit

import UIExtensions

// MARK: - ThemeTabBarDelegate

protocol ThemeTabBarDelegate: AnyObject {
    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool
    
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool
    
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem)
}

// MARK: - ThemeTabBar

open class ThemeTabBar: UITabBar {
    // MARK: Overridden Properties

    override open var items: [UITabBarItem]? {
        didSet {
            rebuild()
        }
    }

    // MARK: Properties

    public var itemEdgeInsets: UIEdgeInsets = .zero

    weak var customDelegate: ThemeTabBarDelegate?
    
    weak var tabBarController: UITabBarController?

    private var containers: [ThemeTabBarItemContainer] = []
    
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    // MARK: Overridden Functions

    override open func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        rebuild()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayout()
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var insides = super.point(inside: point, with: event)
        if !insides {
            for container in containers
                where container.point(
                    inside: CGPoint(
                        x: point.x - container.frame.origin.x,
                        y: point.y - container.frame.origin.y
                    ),
                    with: event
                ) {
                insides = true
            }
        }
        return insides
    }

    // MARK: Functions

    func updateLayout() {
        effectView.frame = bounds
        
        guard let tabBarItems = items else {
            return
        }
        
        let tabBarButtons = subviews.filter { subview -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subview.isKind(of: cls)
            }
            return false
        }
        .sorted { subview1, subview2 -> Bool in
            return subview1.frame.origin.x < subview2.frame.origin.x
        }
        
        if isCustomizing {
            for idx in tabBarItems.indices {
                tabBarButtons[idx].isHidden = false
            }
            for container in containers {
                container.isHidden = true
            }
        } else {
            for (idx, item) in tabBarItems.enumerated() {
                if item is ThemeTabBarItem {
                    tabBarButtons[idx].isHidden = true
                } else {
                    tabBarButtons[idx].isHidden = false
                }
            }
            for container in containers {
                container.isHidden = false
            }
        }
        
        var left: CGFloat = itemEdgeInsets.left
        let top: CGFloat = itemEdgeInsets.top + 1
        let maxWidth = bounds.width - itemEdgeInsets.horizontal
        
        let itemWidth = itemWidth == 0.0 ? maxWidth / CGFloat(containers.count) : itemWidth
        let itemSpacing = itemSpacing == 0.0 ? 0.0 : itemSpacing
        for (idx, container) in containers.enumerated() where !tabBarButtons[idx].frame.isEmpty {
            let maxHeight = bounds.height - top - itemEdgeInsets.bottom
            let itemHeight: CGFloat =
                if tabBarButtons[idx].frame.height > maxHeight {
                    maxHeight
                } else {
                    tabBarButtons[idx].frame.height
                }
            
            container.frame = CGRect(x: left, y: top, width: itemWidth, height: itemHeight)
            left += itemWidth
            left += itemSpacing
        }
    }
    
    func updateAppearance() {
        setShadow(color: .zx010.alpha(0.05), position: .all(10), opacity: 1.0)
        if Theme.current.isDark {
            effectView.effect = UIBlurEffect(style: .dark)
        } else {
            effectView.effect = UIBlurEffect(style: .light)
        }
        effectView.contentView.backgroundColor = .zx009.alpha(0.5)
        backgroundColor = .clear
        
        guard let tabBarItems = items else {
            return
        }
        for item in tabBarItems.compactMap({ $0 as? ThemeTabBarItem }) {
            item.updateAppearance()
        }
    }
    
    @objc
    func highlightedAction(_ sender: AnyObject?) {
        guard let container = sender as? ThemeTabBarItemContainer else {
            return
        }
        let newIndex = max(0, container.tag - 1000)
        guard newIndex < items?.count ?? 0, let item = items?[newIndex], item.isEnabled == true else {
            return
        }
        
        if (customDelegate?.tabBar(self, shouldSelect: item) ?? true) == false {
            return
        }
        
        if let item = item as? ThemeTabBarItem {
            item.contentView.highlighted(animated: true, completion: nil)
        }
    }
    
    @objc
    func unhighlightedAction(_ sender: AnyObject?) {
        guard let container = sender as? ThemeTabBarItemContainer else {
            return
        }
        let newIndex = max(0, container.tag - 1000)
        guard newIndex < items?.count ?? 0, let item = items?[newIndex], item.isEnabled == true else {
            return
        }
        
        if (customDelegate?.tabBar(self, shouldSelect: item) ?? true) == false {
            return
        }
        
        if let item = item as? ThemeTabBarItem {
            item.contentView.unhighlighted(animated: true, completion: nil)
        }
    }
    
    @objc
    func selectAction(_ sender: AnyObject?) {
        guard let container = sender as? ThemeTabBarItemContainer else {
            return
        }
        select(itemAtIndex: container.tag - 1000, animated: true)
    }
    
    @objc
    func select(itemAtIndex idx: Int, animated: Bool) {
        let newIndex = max(0, idx)
        
        var currentIndex: Int = -1
        if let selected = selectedItem {
            currentIndex = items?.firstIndex(of: selected) ?? -1
        }
        guard newIndex < items?.count ?? 0, let item = items?[newIndex], item.isEnabled == true else {
            return
        }
        
        if (customDelegate?.tabBar(self, shouldSelect: item) ?? true) == false {
            return
        }
        
        if (customDelegate?.tabBar(self, shouldHijack: item) ?? false) == true {
            customDelegate?.tabBar(self, didHijack: item)
            if animated, let item = item as? ThemeTabBarItem {
                item.contentView.select(animated: animated, completion: {
                    item.contentView.deselect(animated: false, completion: nil)
                })
            }
            return
        }
        
        if currentIndex != newIndex {
            if currentIndex != -1, currentIndex < items?.count ?? 0 {
                if let currentItem = items?[currentIndex] as? ThemeTabBarItem {
                    currentItem.contentView.deselect(animated: animated, completion: nil)
                }
            }
            if let item = item as? ThemeTabBarItem {
                item.contentView.select(animated: animated, completion: nil)
            }
        } else if currentIndex == newIndex {
            if let item = item as? ThemeTabBarItem {
                item.contentView.reselect(animated: animated, completion: nil)
            }
            
            if let tabBarController {
                var navigationController: UINavigationController?
                if let naviController = tabBarController.selectedViewController as? UINavigationController {
                    navigationController = naviController
                } else if let naviController = tabBarController.selectedViewController?.navigationController {
                    navigationController = naviController
                }
                
                if let navigationController {
                    if navigationController.viewControllers.contains(tabBarController) {
                        if
                            navigationController.viewControllers.count > 1,
                            navigationController.viewControllers.last != tabBarController {
                            navigationController.popToViewController(tabBarController, animated: true)
                        }
                    } else {
                        if navigationController.viewControllers.count > 1 {
                            navigationController.popToRootViewController(animated: animated)
                        }
                    }
                }
            }
        }
        
        delegate?.tabBar?(self, didSelect: item)
    }
    
    private func removeAll() {
        for container in containers {
            container.removeFromSuperview()
        }
        containers.removeAll()
        effectView.removeFromSuperview()
    }
    
    private func rebuild() {
        removeAll()
        guard let tabBarItems = items else {
            return
        }
        
        addSubview(effectView)
        
        for (idx, item) in tabBarItems.enumerated() {
            let container = ThemeTabBarItemContainer(self, tag: 1000 + idx)
            addSubview(container)
            containers.append(container)
            
            if let item = item as? ThemeTabBarItem {
                container.addSubview(item.contentView)
            }
        }
        
        setNeedsLayout()
    }
}

// MARK: - ThemeTabBarItem

open class ThemeTabBarItem: UITabBarItem {
    // MARK: Overridden Properties

    override open var tag: Int {
        get { contentView.tag }
        set { contentView.tag = newValue }
    }
    
    override open var isEnabled: Bool {
        get { contentView.isEnabled }
        set { contentView.isEnabled = newValue }
    }
    
    override open var title: String? {
        get { contentView.title }
        set { contentView.title = newValue }
    }
    
    override open var image: UIImage? {
        didSet { contentView.image = image }
    }
    
    override open var selectedImage: UIImage? {
        get { contentView.selectedImage }
        set { contentView.selectedImage = newValue }
    }
    
    override open var badgeValue: String? {
        get { contentView.badgeValue }
        set { contentView.badgeValue = newValue }
    }
    
    override open var titlePositionAdjustment: UIOffset {
        get { contentView.titlePositionAdjustment }
        set { contentView.titlePositionAdjustment = newValue }
    }
    
    override open var badgeColor: UIColor? {
        get { contentView.badgeColor }
        set { contentView.badgeColor = newValue }
    }

    // MARK: Computed Properties

    open var textColor: UIColor {
        get { contentView.textColor }
        set { contentView.textColor = newValue }
    }
    
    open var selectedTextColor: UIColor {
        get { contentView.selectedTextColor }
        set { contentView.selectedTextColor = newValue }
    }
    
    open var disabledTextColor: UIColor {
        get { contentView.disabledTextColor }
        set { contentView.disabledTextColor = newValue }
    }
    
    open var titleFont: UIFont {
        get { contentView.titleFont }
        set { contentView.titleFont = newValue }
    }
    
    open var selectedTitleFont: UIFont? {
        get { contentView.selectedTitleFont }
        set { contentView.selectedTitleFont = newValue }
    }
    
    open var disabledImage: UIImage? {
        get { contentView.disabledImage }
        set { contentView.disabledImage = newValue }
    }
    
    open var imageSize: CGSize? {
        get { contentView.imageSize }
        set { contentView.imageSize = newValue }
    }
    
    open var selectedImageSize: CGSize? {
        get { contentView.selectedImageSize }
        set { contentView.selectedImageSize = newValue }
    }
    
    open var disabledImageSize: CGSize? {
        get { contentView.disabledImageSize }
        set { contentView.disabledImageSize = newValue }
    }
    
    open var imageColor: UIColor {
        get { contentView.imageColor }
        set { contentView.imageColor = newValue }
    }
    
    open var selectedImageColor: UIColor {
        get { contentView.selectedImageColor }
        set { contentView.selectedImageColor = newValue }
    }
    
    open var disabledImageColor: UIColor {
        get { contentView.disabledImageColor }
        set { contentView.disabledImageColor = newValue }
    }
    
    open var backdropColor: UIColor {
        get { contentView.backdropColor }
        set { contentView.backdropColor = newValue }
    }
    
    open var selectedBackdropColor: UIColor {
        get { contentView.selectedBackdropColor }
        set { contentView.selectedBackdropColor = newValue }
    }
    
    open var disabledBackdropColor: UIColor {
        get { contentView.disabledBackdropColor }
        set { contentView.disabledBackdropColor = newValue }
    }
    
    open var renderingMode: UIImage.RenderingMode {
        get { contentView.renderingMode }
        set { contentView.renderingMode = newValue }
    }
    
    open var insets: UIEdgeInsets {
        get { contentView.insets }
        set { contentView.insets = newValue }
    }
    
    open var contentView = ThemeTabBarItemContentView() {
        didSet {
            contentView.updateLayout()
            contentView.updateAppearance()
        }
    }

    // MARK: Lifecycle

    public init(
        _ contentView: ThemeTabBarItemContentView = ThemeTabBarItemContentView(),
        title: String? = nil,
        image: UIImage? = nil,
        selectedImage: UIImage? = nil,
        tag: Int = 0
    ) {
        super.init()
        self.contentView = contentView
        self.contentView.title = title
        self.contentView.image = image
        self.contentView.selectedImage = selectedImage
        self.contentView.tag = tag
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    open func updateAppearance() {
        contentView.updateAppearance()
    }
}

// MARK: - ThemeTabBarItemContainer

class ThemeTabBarItemContainer: UIControl {
    // MARK: Lifecycle

    init(_ target: AnyObject?, tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
        addTarget(target, action: #selector(ThemeTabBar.selectAction(_:)), for: .touchUpInside)
        addTarget(target, action: #selector(ThemeTabBar.highlightedAction(_:)), for: .touchDown)
        addTarget(target, action: #selector(ThemeTabBar.highlightedAction(_:)), for: .touchDragEnter)
        addTarget(target, action: #selector(ThemeTabBar.unhighlightedAction(_:)), for: .touchDragExit)
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overridden Functions

    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in subviews {
            if let subview = subview as? ThemeTabBarItemContentView {
                subview.frame = CGRect(
                    x: subview.insets.left,
                    y: subview.insets.top,
                    width: bounds.width - subview.insets.left - subview.insets.right,
                    height: bounds.height - subview.insets.top - subview.insets.bottom
                )
                subview.updateLayout()
            }
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var insides = super.point(inside: point, with: event)
        if !insides {
            for subview in subviews where
                subview.point(
                    inside: CGPoint(
                        x: point.x - subview.frame.origin.x,
                        y: point.y - subview.frame.origin.y
                    ),
                    with: event
                ) {
                insides = true
            }
        }
        return insides
    }
}

// MARK: - ThemeTabBarItemContentView

open class ThemeTabBarItemContentView: UIView {
    // MARK: Properties

    open var isSelected = false
    
    open var isHighlighted = false
    
    open var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    open var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .clear
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    // MARK: Computed Properties

    open var title: String? {
        didSet {
            titleLabel.text = title
            updateLayout()
        }
    }
    
    open var image: UIImage? {
        didSet {
            if !isSelected {
                updateAppearance()
            }
        }
    }
    
    open var selectedImage: UIImage? {
        didSet {
            if isSelected {
                updateAppearance()
            }
        }
    }
    
    open var disabledImage: UIImage? {
        didSet {
            if !isEnabled {
                updateAppearance()
            }
        }
    }
    
    open var isEnabled = true {
        didSet {
            updateAppearance()
        }
    }
    
    open var textColor: UIColor = .zx002 {
        didSet {
            if !isSelected {
                titleLabel.textColor = textColor
            }
        }
    }
    
    open var selectedTextColor: UIColor = .cg005 {
        didSet {
            if isSelected {
                titleLabel.textColor = selectedTextColor
            }
        }
    }
    
    open var disabledTextColor: UIColor = .zx004 {
        didSet {
            if !isEnabled {
                titleLabel.textColor = disabledTextColor
            }
        }
    }

    open var titleFont: UIFont = .captionM {
        didSet {
            if titleFont != oldValue {
                updateLayout()
            }
        }
    }
    
    open var selectedTitleFont: UIFont? {
        didSet {
            if selectedTitleFont != oldValue {
                updateLayout()
            }
        }
    }
    
    open var imageColor: UIColor = .zx002 {
        didSet {
            if !isSelected {
                imageView.image = image?.tint(imageColor)
            }
        }
    }

    open var selectedImageColor: UIColor = .cg005 {
        didSet {
            if isSelected {
                imageView.image = (selectedImage ?? image)?.tint(selectedImageColor)
            }
        }
    }
    
    open var disabledImageColor: UIColor = .zx004 {
        didSet {
            if !isEnabled {
                imageView.image = image?.tint(disabledImageColor)
            }
        }
    }
    
    open var imageSize: CGSize? {
        didSet {
            if imageSize != oldValue {
                updateLayout()
            }
        }
    }
    
    open var selectedImageSize: CGSize? {
        didSet {
            if selectedImageSize != oldValue {
                updateLayout()
            }
        }
    }
    
    open var disabledImageSize: CGSize? {
        didSet {
            if disabledImageSize != oldValue {
                updateLayout()
            }
        }
    }
    
    open var backdropColor: UIColor = .clear {
        didSet {
            if !isSelected {
                backgroundColor = backdropColor
            }
        }
    }
    
    open var selectedBackdropColor: UIColor = .clear {
        didSet {
            if isSelected {
                backgroundColor = selectedBackdropColor
            }
        }
    }
    
    open var disabledBackdropColor: UIColor = .clear {
        didSet {
            if !isEnabled {
                backgroundColor = disabledBackdropColor
            }
        }
    }
    
    open var renderingMode: UIImage.RenderingMode = .alwaysOriginal {
        didSet {
            updateAppearance()
        }
    }
    
    open var titlePositionAdjustment = UIOffset.zero {
        didSet {
            updateLayout()
        }
    }
    
    open var insets = UIEdgeInsets.zero {
        didSet {
            updateLayout()
        }
    }
    
    open var badgeValue: String? {
        didSet {
            if let value = badgeValue {
                badgeView.badgeValue = value
                if badgeView.superview == nil {
                    addSubview(badgeView)
                }
                updateLayout()
            } else {
                badgeView.removeFromSuperview()
            }
            badgeChanged(animated: true, completion: nil)
        }
    }
    
    open var badgeColor: UIColor? {
        didSet {
            if let color = badgeColor {
                badgeView.badgeColor = color
            } else {
                badgeView.badgeColor = .cg002
            }
        }
    }
    
    open var badgeView = ThemeTabBarItemBadgeView() {
        willSet {
            if badgeView.superview != nil {
                badgeView.removeFromSuperview()
            }
        }
        didSet {
            if badgeView.superview != nil {
                updateLayout()
            }
        }
    }
    
    open var badgeOffset = UIOffset(horizontal: 8.0, vertical: -20.0) {
        didSet {
            if badgeOffset != oldValue {
                updateLayout()
            }
        }
    }

    // MARK: Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        titleLabel.textColor = textColor
        imageView.tintColor = imageColor
        backgroundColor = backdropColor
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    open func updateAppearance() {
        var selectedImage = (selectedImage ?? image)?.tint(selectedImageColor)
        if let selectedImageSize {
            selectedImage = selectedImage?.resize(selectedImageSize)
        }
        var normalImage = image?.tint(imageColor)
        if let imageSize {
            normalImage = normalImage?.resize(imageSize)
        }
        var disabledImage = (disabledImage ?? image)?.tint(disabledImageColor)
        if let disabledImageSize {
            disabledImage = disabledImage?.resize(disabledImageSize)
        }
        if isEnabled {
            imageView.image = isSelected ? selectedImage : normalImage
            titleLabel.textColor = isSelected ? selectedTextColor : textColor
            backgroundColor = isSelected ? selectedBackdropColor : backdropColor
        } else {
            imageView.image = disabledImage
            titleLabel.textColor = disabledTextColor
            backgroundColor = disabledBackdropColor
        }
    }
    
    open func updateLayout() {
        let width = bounds.width
        let height = bounds.height
        
        imageView.isHidden = (imageView.image == nil)
        titleLabel.isHidden = (titleLabel.text == nil)
        if isSelected {
            if let imageSize {
                imageView.image = imageView.image?.resize(imageSize)
            }
            titleLabel.font = selectedTitleFont ?? titleFont
        } else {
            if let selectedImageSize {
                imageView.image = imageView.image?.resize(selectedImageSize)
            }
            titleLabel.font = titleFont
        }
        
        if !imageView.isHidden, !titleLabel.isHidden {
            titleLabel.sizeToFit()
            imageView.sizeToFit()
            titleLabel.frame = CGRect(
                x: (width - titleLabel.bounds.width) / 2.0
                    + titlePositionAdjustment.horizontal,
                y: height - titleLabel.bounds.height - 1.0
                    + titlePositionAdjustment.vertical,
                width: titleLabel.bounds.width,
                height: titleLabel.bounds.height
            )
            imageView.frame = CGRect(
                x: (width - imageView.bounds.width) / 2.0,
                y: (height - imageView.bounds.height) / 2.0 - 6.0,
                width: imageView.bounds.width,
                height: imageView.bounds.height
            )
        } else if !imageView.isHidden {
            imageView.sizeToFit()
            imageView.center = CGPoint(x: width / 2.0, y: height / 2.0)
        } else if !titleLabel.isHidden {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: width / 2.0, y: height / 2.0)
        }
        
        if badgeView.superview != nil {
            let size = badgeView.sizeThatFits(frame.size)
            badgeView.frame = CGRect(
                origin: CGPoint(
                    x: width / 2.0 + badgeOffset.horizontal,
                    y: height / 2.0 + badgeOffset.vertical
                ),
                size: size
            )
            badgeView.setNeedsLayout()
        }
    }

    open func selectAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func deselectAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func reselectAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func highlightedAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func unhighlightedAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func badgeChangedAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }

    final func select(animated: Bool, completion: (() -> Void)?) {
        isSelected = true
        if isEnabled, isHighlighted {
            isHighlighted = false
            unhighlightedAnimation(animated: animated, completion: { [weak self] in
                self?.updateAppearance()
                self?.selectAnimation(animated: animated, completion: completion)
            })
        } else {
            updateAppearance()
            selectAnimation(animated: animated, completion: completion)
        }
    }
    
    final func deselect(animated: Bool, completion: (() -> Void)?) {
        isSelected = false
        updateAppearance()
        deselectAnimation(animated: animated, completion: completion)
    }
    
    final func reselect(animated: Bool, completion: (() -> Void)?) {
        if isSelected == false {
            select(animated: animated, completion: completion)
        } else {
            if isEnabled, isHighlighted {
                isHighlighted = false
                unhighlightedAnimation(animated: animated, completion: { [weak self] in
                    self?.reselectAnimation(animated: animated, completion: completion)
                })
            } else {
                reselectAnimation(animated: animated, completion: completion)
            }
        }
    }
    
    final func highlighted(animated: Bool, completion: (() -> Void)?) {
        if !isEnabled {
            return
        }
        if isHighlighted == true {
            return
        }
        isHighlighted = true
        highlightedAnimation(animated: animated, completion: completion)
    }
    
    final func unhighlighted(animated: Bool, completion: (() -> Void)?) {
        if !isEnabled {
            return
        }
        if !isHighlighted {
            return
        }
        isHighlighted = false
        unhighlightedAnimation(animated: animated, completion: completion)
    }
    
    func badgeChanged(animated: Bool, completion: (() -> Void)?) {
        badgeChangedAnimation(animated: animated, completion: completion)
    }
}

// MARK: - ThemeTabBarItemBadgeView

open class ThemeTabBarItemBadgeView: UIView {
    // MARK: Properties

    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    open var badgeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .microM
        label.textColor = .zx017
        label.backgroundColor = .clear
        return label
    }()

    // MARK: Computed Properties

    open var badgeColor: UIColor? = .cg002 {
        didSet {
            imageView.backgroundColor = badgeColor
        }
    }
    
    open var badgeValue: String? {
        didSet {
            badgeLabel.text = badgeValue
        }
    }

    // MARK: Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(badgeLabel)
        imageView.backgroundColor = badgeColor
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overridden Functions

    override open func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        
        guard let badgeValue else {
            imageView.isHidden = true
            badgeLabel.isHidden = true
            return
        }
        
        imageView.isHidden = false
        badgeLabel.isHidden = false
        
        if badgeValue.isEmpty {
            imageView.frame = CGRect(
                x: (bounds.width - 8.0) / 2.0,
                y: (bounds.height - 8.0) / 2.0,
                width: 8,
                height: 8
            )
        } else {
            imageView.frame = bounds
        }
        imageView.layer.cornerRadius = imageView.bounds.size.height / 2.0
        badgeLabel.sizeToFit()
        badgeLabel.center = imageView.center
    }
    
    override open func sizeThatFits(_: CGSize) -> CGSize {
        guard badgeValue != nil else {
            return CGSize(width: 12, height: 12)
        }
        let textSize = badgeLabel.sizeThatFits(
            CGSize(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        return CGSize(width: max(12.0, textSize.width + 10.0), height: 12.0)
    }
}
