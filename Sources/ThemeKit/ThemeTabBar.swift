//
//  ThemeTabBar.swift
//  ThemeKit
//
//  Created by Sun on 2024/8/23.
//

import UIKit

import UIExtensions

protocol ThemeTabBarDelegate: AnyObject {
    
    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool
    
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool
    
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem)
}

open class ThemeTabBar: UITabBar {
    
    weak var customDelegate: ThemeTabBarDelegate?
    
    weak var tabBarController: UITabBarController?
    
    public var itemEdgeInsets: UIEdgeInsets = .zero
    
    private var containers: [ThemeTabBarItemContainer] = []
    
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    override open var items: [UITabBarItem]? {
        didSet {
            self.rebuild()
        }
    }
    
    override open func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        self.rebuild()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateLayout()
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var insides = super.point(inside: point, with: event)
        if !insides {
            for container in containers
            where container.point(
                inside: CGPoint(x: point.x - container.frame.origin.x,
                                y: point.y - container.frame.origin.y),
                with: event) {
                insides = true
            }
            
        }
        return insides
    }
    
    func updateLayout() {
        
        self.effectView.frame = self.bounds
        
        guard let tabBarItems = self.items else {
            return
        }
        
        let tabBarButtons = subviews.filter { subview -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subview.isKind(of: cls)
            }
            return false
        }
            .sorted { (subview1, subview2) -> Bool in
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
            let itemHeight: CGFloat
            if tabBarButtons[idx].frame.height > maxHeight {
                itemHeight = maxHeight
            } else {
                itemHeight = tabBarButtons[idx].frame.height
            }
            
            container.frame = CGRect(x: left, y: top, width: itemWidth, height: itemHeight)
            left += itemWidth
            left += itemSpacing
        }
    }
    
    func updateAppearance() {
        setShadow(color: .zx010.alpha(0.05), position: .all(10), opacity: 1.0)
        
        if Theme.current.statusBarStyle == .lightContent {
            effectView.effect = UIBlurEffect(style: .dark)
        } else {
            effectView.effect = UIBlurEffect(style: .light)
        }
        effectView.contentView.backgroundColor = .zx009.alpha(0.5)
        backgroundColor = .clear
        
        guard let tabBarItems = self.items else {
            return
        }
        for item in tabBarItems.compactMap({ $0 as? ThemeTabBarItem }) {
            item.updateAppearance()
        }
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
        guard let tabBarItems = self.items else {
            return
        }
        
        self.addSubview(self.effectView)
        
        for (idx, item) in tabBarItems.enumerated() {
            let container = ThemeTabBarItemContainer(self, tag: 1_000 + idx)
            self.addSubview(container)
            self.containers.append(container)
            
            if let item = item as? ThemeTabBarItem {
                container.addSubview(item.contentView)
            }
        }
        
        self.setNeedsLayout()
    }
    
    @objc
    func highlightedAction(_ sender: AnyObject?) {
        guard let container = sender as? ThemeTabBarItemContainer else {
            return
        }
        let newIndex = max(0, container.tag - 1_000)
        guard newIndex < items?.count ?? 0, let item = self.items?[newIndex], item.isEnabled == true else {
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
        let newIndex = max(0, container.tag - 1_000)
        guard newIndex < items?.count ?? 0, let item = self.items?[newIndex], item.isEnabled == true else {
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
        select(itemAtIndex: container.tag - 1_000, animated: true)
    }
    
    @objc
    func select(itemAtIndex idx: Int, animated: Bool) {
        let newIndex = max(0, idx)
        
        var currentIndex: Int = -1
        if let selected = selectedItem {
            currentIndex = items?.firstIndex(of: selected) ?? -1
        }
        guard newIndex < items?.count ?? 0, let item = self.items?[newIndex], item.isEnabled == true else {
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
            if currentIndex != -1 && currentIndex < items?.count ?? 0 {
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
            
            if let tabBarController = tabBarController {
                var navigationController: UINavigationController?
                if let naviController = tabBarController.selectedViewController as? UINavigationController {
                    navigationController = naviController
                } else if let naviController = tabBarController.selectedViewController?.navigationController {
                    navigationController = naviController
                }
                
                if let navigationController = navigationController {
                    if navigationController.viewControllers.contains(tabBarController) {
                        if navigationController.viewControllers.count > 1
                            && navigationController.viewControllers.last != tabBarController {
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
    
}

open class ThemeTabBarItem: UITabBarItem {
    
    override open var tag: Int {
        get { self.contentView.tag }
        set { self.contentView.tag = newValue }
    }
    
    override open var isEnabled: Bool {
        get { self.contentView.isEnabled }
        set { self.contentView.isEnabled = newValue }
    }
    
    override open var title: String? {
        get { self.contentView.title }
        set { self.contentView.title = newValue }
    }
    
    open var textColor: UIColor {
        get { contentView.textColor }
        set { self.contentView.textColor = newValue }
    }
    
    open var selectedTextColor: UIColor {
        get { contentView.selectedTextColor }
        set { self.contentView.selectedTextColor = newValue }
    }
    
    open var titleFont: UIFont {
        get { contentView.titleFont }
        set { self.contentView.titleFont = newValue }
    }
    
    open var selectedTitleFont: UIFont? {
        get { contentView.selectedTitleFont }
        set { self.contentView.selectedTitleFont = newValue }
    }
    
    override open var image: UIImage? {
        didSet { self.contentView.image = image }
    }
    
    open var imageSize: CGSize? {
        get { return contentView.imageSize }
        set { contentView.imageSize = newValue }
    }
    
    open var selectedImageSize: CGSize? {
        get { return contentView.selectedImageSize }
        set { contentView.selectedImageSize = newValue }
    }
    
    override open var selectedImage: UIImage? {
        get { return contentView.selectedImage }
        set { contentView.selectedImage = newValue }
    }
    
    open var imageColor: UIColor {
        get { contentView.imageColor }
        set { self.contentView.imageColor = newValue }
    }
    
    open var highlightedImageColor: UIColor {
        get { contentView.selectedImageColor }
        set { self.contentView.selectedImageColor = newValue }
    }
    
    open var backdropColor: UIColor {
        get { contentView.backdropColor }
        set { self.contentView.backdropColor = newValue }
    }
    
    open var highlightedBackdropColor: UIColor {
        get { contentView.selectedBackdropColor }
        set { self.contentView.selectedBackdropColor = newValue }
    }
    
    override open var badgeValue: String? {
        get { return contentView.badgeValue }
        set { contentView.badgeValue = newValue }
    }
    
    override open var titlePositionAdjustment: UIOffset {
        get { return contentView.titlePositionAdjustment }
        set { contentView.titlePositionAdjustment = newValue }
    }
    
    override open var badgeColor: UIColor? {
        get { return contentView.badgeColor }
        set { contentView.badgeColor = newValue }
    }
    
    open var renderingMode: UIImage.RenderingMode {
        get { contentView.renderingMode }
        set { contentView.renderingMode = newValue }
    }
    
    open var insets: UIEdgeInsets {
        get { contentView.insets }
        set { contentView.insets = newValue }
    }
    
    open var contentView: ThemeTabBarItemContentView = ThemeTabBarItemContentView() {
        didSet {
            self.contentView.updateLayout()
            self.contentView.updateAppearance()
        }
    }
    
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
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func updateAppearance() {
        self.contentView.updateAppearance()
    }
}

class ThemeTabBarItemContainer: UIControl {
    
    init(_ target: AnyObject?, tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
        self.addTarget(target, action: #selector(ThemeTabBar.selectAction(_:)), for: .touchUpInside)
        self.addTarget(target, action: #selector(ThemeTabBar.highlightedAction(_:)), for: .touchDown)
        self.addTarget(target, action: #selector(ThemeTabBar.highlightedAction(_:)), for: .touchDragEnter)
        self.addTarget(target, action: #selector(ThemeTabBar.unhighlightedAction(_:)), for: .touchDragExit)
        self.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in self.subviews {
            if let subview = subview as? ThemeTabBarItemContentView {
                subview.frame = CGRect(x: subview.insets.left,
                                       y: subview.insets.top,
                                       width: bounds.width - subview.insets.left - subview.insets.right,
                                       height: bounds.height - subview.insets.top - subview.insets.bottom)
                subview.updateLayout()
            }
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var insides = super.point(inside: point, with: event)
        if !insides {
            for subview in self.subviews where
            subview.point(
                inside: CGPoint(x: point.x - subview.frame.origin.x,
                                y: point.y - subview.frame.origin.y),
                with: event) {
                    insides = true
                }
        }
        return insides
    }
}

open class ThemeTabBarItemContentView: UIView {
    
    open var title: String? {
        didSet {
            self.titleLabel.text = title
            self.updateLayout()
        }
    }
    
    open var image: UIImage? {
        didSet {
            if !isSelected { self.updateAppearance() }
        }
    }
    
    open var selectedImage: UIImage? {
        didSet {
            if isSelected { self.updateAppearance() }
        }
    }
    
    open var isEnabled = true
    
    open var isSelected = false
    
    open var isHighlighted = false
    
    open var textColor: UIColor = .zx003 {
        didSet {
            if !isSelected { titleLabel.textColor = textColor }
        }
    }
    
    open var selectedTextColor: UIColor = .cg005 {
        didSet {
            if isSelected { titleLabel.textColor = selectedTextColor }
        }
    }

    open var titleFont: UIFont = .captionM {
        didSet {
            if titleFont != oldValue {
                self.updateLayout()
            }
        }
    }
    
    open var selectedTitleFont: UIFont? {
        didSet {
            if selectedTitleFont != oldValue {
                self.updateLayout()
            }
        }
    }
    
    open var imageColor: UIColor = .zx003 {
        didSet {
            if !isSelected { imageView.image = image?.tint(imageColor) }
        }
    }

    open var selectedImageColor: UIColor = .cg005 {
        didSet {
            if isSelected { imageView.image = (selectedImage ?? image)?.tint(selectedImageColor) }
        }
    }
    
    open var imageSize: CGSize? {
        didSet {
            if imageSize != oldValue {
                self.updateLayout()
            }
        }
    }
    
    open var selectedImageSize: CGSize?{
        didSet {
            if imageSize != oldValue {
                self.updateLayout()
            }
        }
    }
    
    open var backdropColor: UIColor = .clear {
        didSet {
            if !isSelected { backgroundColor = backdropColor }
        }
    }
    
    open var selectedBackdropColor: UIColor = .clear {
        didSet {
            if isSelected { backgroundColor = selectedBackdropColor }
        }
    }
    
    open var renderingMode: UIImage.RenderingMode = .alwaysOriginal {
        didSet {
            self.updateAppearance()
        }
    }
    
    open var titlePositionAdjustment: UIOffset = UIOffset.zero {
        didSet {
            self.updateLayout()
        }
    }
    
    open var insets = UIEdgeInsets.zero {
        didSet {
            self.updateLayout()
        }
    }
    
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
    
    open var badgeValue: String? {
        didSet {
            if let value = badgeValue {
                self.badgeView.badgeValue = value
                if badgeView.superview == nil {
                    self.addSubview(badgeView)
                }
                self.updateLayout()
            } else {
                self.badgeView.removeFromSuperview()
            }
            badgeChanged(animated: true, completion: nil)
        }
    }
    
    open var badgeColor: UIColor? {
        didSet {
            if let color = badgeColor {
                self.badgeView.badgeColor = color
            } else {
                self.badgeView.badgeColor = .fz001
            }
        }
    }
    
    open var badgeView: ThemeTabBarItemBadgeView = ThemeTabBarItemBadgeView() {
        willSet {
            if badgeView.superview != nil {
                badgeView.removeFromSuperview()
            }
        }
        didSet {
            if badgeView.superview != nil {
                self.updateLayout()
            }
        }
    }
    
    open var badgeOffset: UIOffset = UIOffset(horizontal: 6.0, vertical: -16.0) {
        didSet {
            if badgeOffset != oldValue {
                self.updateLayout()
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        self.titleLabel.textColor = self.textColor
        self.imageView.tintColor = self.imageColor
        self.backgroundColor = self.backdropColor
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func updateAppearance() {
        var selectedImage = (self.selectedImage ?? self.image)?.tint(self.selectedImageColor)
        if let selectedImageSize {
            selectedImage = selectedImage?.resize(selectedImageSize)
        }
        var normalImage = self.image?.tint(self.imageColor)
        if let imageSize {
            normalImage = normalImage?.resize(imageSize)
        }
        
        self.imageView.image = self.isSelected ? selectedImage : normalImage
        self.titleLabel.textColor = self.isSelected ? self.selectedTextColor : self.textColor
        self.backgroundColor = self.isSelected ? self.selectedBackdropColor : self.backdropColor
    }
    
    open func updateLayout() {
        let width = self.bounds.width
        let height = self.bounds.height
        
        imageView.isHidden = (imageView.image == nil)
        titleLabel.isHidden = (titleLabel.text == nil)
        if self.isSelected {
            if let imageSize {
                imageView.image = imageView.image?.resize(imageSize)
            }
            titleLabel.font = self.selectedTitleFont ?? self.titleFont
        } else {
            if let selectedImageSize {
                imageView.image = imageView.image?.resize(selectedImageSize)
            }
            titleLabel.font = self.titleFont
        }
        
        if !imageView.isHidden && !titleLabel.isHidden {
            titleLabel.sizeToFit()
            imageView.sizeToFit()
            titleLabel.frame = CGRect(x: (width - titleLabel.bounds.width) / 2.0
                                      + titlePositionAdjustment.horizontal,
                                      y: height - titleLabel.bounds.height - 1.0
                                      + titlePositionAdjustment.vertical,
                                      width: titleLabel.bounds.width,
                                      height: titleLabel.bounds.height)
            imageView.frame = CGRect(x: (width - imageView.bounds.width) / 2.0,
                                     y: (height - imageView.bounds.height) / 2.0 - 6.0,
                                     width: imageView.bounds.width,
                                     height: imageView.bounds.height)
        } else if !imageView.isHidden {
            imageView.sizeToFit()
            imageView.center = CGPoint(x: width / 2.0, y: height / 2.0)
        } else if !titleLabel.isHidden {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: width / 2.0, y: height / 2.0)
        }
        
        if badgeView.superview != nil {
            let size = badgeView.sizeThatFits(self.frame.size)
            badgeView.frame = CGRect(origin: CGPoint(x: width / 2.0 + badgeOffset.horizontal,
                                                     y: height / 2.0 + badgeOffset.vertical),
                                     size: size)
            badgeView.setNeedsLayout()
        }
    }

    final func select(animated: Bool, completion: (() -> Void)?) {
        isSelected = true
        if isEnabled && isHighlighted {
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
        self.deselectAnimation(animated: animated, completion: completion)
    }
    
    final func reselect(animated: Bool, completion: (() -> Void)?) {
        if isSelected == false {
            select(animated: animated, completion: completion)
        } else {
            if isEnabled && isHighlighted {
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
        self.highlightedAnimation(animated: animated, completion: completion)
    }
    
    final func unhighlighted(animated: Bool, completion: (() -> Void)?) {
        if !isEnabled {
            return
        }
        if !isHighlighted {
            return
        }
        isHighlighted = false
        self.unhighlightedAnimation(animated: animated, completion: completion)
    }
    
    func badgeChanged(animated: Bool, completion: (() -> Void)?) {
        self.badgeChangedAnimation(animated: animated, completion: completion)
    }

    open func selectAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func deselectAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func reselectAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func highlightedAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func unhighlightedAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
    
    open func badgeChangedAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }
}

open class ThemeTabBarItemBadgeView: UIView {
    
    open var badgeColor: UIColor? = .fz001 {
        didSet {
            imageView.backgroundColor = badgeColor
        }
    }
    
    open var badgeValue: String? {
        didSet {
            badgeLabel.text = badgeValue
        }
    }
    
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    open var badgeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .caption
        label.textColor = .zx017
        label.backgroundColor = .clear
        return label
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(badgeLabel)
        imageView.backgroundColor = self.badgeColor
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height / 2
        
        guard let badgeValue = badgeValue else {
            imageView.isHidden = true
            badgeLabel.isHidden = true
            return
        }
        
        imageView.isHidden = false
        badgeLabel.isHidden = false
        
        if badgeValue.isEmpty {
            imageView.frame = CGRect(x: (bounds.width - 6.0) / 2.0,
                                     y: (bounds.height - 6.0) / 2.0,
                                     width: 6,
                                     height: 6)
        } else {
            imageView.frame = bounds
        }
        imageView.layer.cornerRadius = imageView.bounds.size.height / 2.0
        badgeLabel.sizeToFit()
        badgeLabel.center = imageView.center
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard badgeValue != nil else {
            return CGSize(width: 10.0, height: 10.0)
        }
        let textSize = badgeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                      height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: max(10.0, textSize.width + 10.0), height: 10.0)
    }
}
