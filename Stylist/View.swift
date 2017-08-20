//
//  Styles.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    @IBInspectable public var styles: [String] {
        get {
            return Stylist.shared.getStyles(view: self)
        }
        set {
            Stylist.shared.setStyles(view: self, styles: newValue)
        }
    }

    @IBInspectable public var style: String? {
        get {
            return Stylist.shared.getStyles(view: self).first
        }
        set {
            Stylist.shared.setStyles(view: self, styles: newValue != nil ? [newValue!] : [])
        }
    }
}

extension UIBarItem {

    @IBInspectable public var styles: [String] {
        get {
            return Stylist.shared.getStyles(view: self)
        }
        set {
            Stylist.shared.setStyles(view: self, styles: newValue)
        }
    }

    @IBInspectable public var style: String? {
        get {
            return Stylist.shared.getStyles(view: self).first
        }
        set {
            Stylist.shared.setStyles(view: self, styles: newValue != nil ? [newValue!] : [])
        }
    }
}

extension UIAppearance {

    func apply(style: Style) {
        style.attributes.forEach(apply)
    }

    func apply(styleAttribute: StyleAttribute) {

        guard styleAttribute.interfaceIdiom == .unspecified || styleAttribute.interfaceIdiom == UIDevice.current.userInterfaceIdiom else { return }

        if let view = self as? UIView {
            view.apply(styleAttribute: styleAttribute)
        } else if let view = self as? UIBarItem {
            view.apply(styleAttribute: styleAttribute)
        }
    }
}

extension UIView {

    func apply(styleAttribute: StyleAttribute) {
        switch styleAttribute.attribute {
        case .backgroundColor(let color):
            self.backgroundColor = color
        case .cornerRadius(let radius):
            self.layer.cornerRadius = CGFloat(radius)
        case .borderColor(let color):
            self.layer.borderColor = color.cgColor
        case .tintColor(let color):
            self.tintColor = color
        case .borderWidth(let width):
            self.layer.borderWidth = CGFloat(width)
        case .alpha(let alpha):
            self.alpha = CGFloat(alpha)
        case .shadowAlpha(let alpha):
            layer.shadowOpacity = Float(alpha)
        case .image(let image):
            if let view = self as? UIButton {
                view.setImage(image, for: .normal)
            }
        case .backgroundImage(let image):
            if let view = self as? UIButton {
                view.setBackgroundImage(image, for: styleAttribute.controlState)
            }
            else {
                backgroundColor = UIColor(patternImage: image)
            }
        case .imageEdgeInsets(let insets):
            if let view = self as? UIButton {
                view.imageEdgeInsets = insets
            }
        case .titleEdgeInsets(let insets):
            if let view = self as? UIButton {
                view.titleEdgeInsets = insets
            }
        case .contentEdgeInsets(let insets):
            if let view = self as? UIButton {
                view.contentEdgeInsets = insets
            }
        case .textColor(let color):
            if let view = self as? UILabel {
                view.textColor = color
            } else if let view = self as? UITextView {
                view.textColor = color
            } else if let view = self as? UITextField {
                view.textColor = color
            } else if let view = self as? UIButton {
                view.setTitleColor(color, for: styleAttribute.controlState)
            }
        case .font(let font):
            if let view = self as? UILabel {
                view.font = font
            } else if let view = self as? UITextView {
                view.font = font
            } else if let view = self as? UITextField {
                view.font = font
            } else if let view = self as? UIButton {
                view.titleLabel?.font = font
            }
        case .widthAnchor(let anchor):
            if let existingContraint = self.constraints.first(where: {$0.firstItem === self && $0.firstAttribute == .width && $0.relation == .equal }) {
                existingContraint.isActive = false
            }


            let contraint:NSLayoutConstraint

            if anchor.ratio {
                contraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: anchor.equality, toItem: self, attribute: .height, multiplier: anchor.constant, constant: 0)
            } else {
                contraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: anchor.equality, toItem: nil, attribute: .height, multiplier: 1, constant: anchor.constant)
            }

            contraint.isActive = true
            self.translatesAutoresizingMaskIntoConstraints = false

        case .heightAnchor(let anchor):
            if let existingContraint = self.constraints.first(where: {$0.firstItem === self && $0.firstAttribute == .height && $0.relation == .equal }) {
                existingContraint.isActive = false
            }

            let contraint:NSLayoutConstraint

            if anchor.ratio {
                contraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: anchor.equality, toItem: self, attribute: .width, multiplier: anchor.constant, constant: 0)
            } else {
                contraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: anchor.equality, toItem: nil, attribute: .width, multiplier: 1, constant: anchor.constant)
            }

            contraint.isActive = true
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

extension UIBarItem {

    func apply(styleAttribute: StyleAttribute) {
        switch styleAttribute.attribute {
        case .backgroundImage(let image):
            if let view = self as? UIBarButtonItem {
                view.setBackgroundImage(image, for: styleAttribute.controlState, barMetrics: styleAttribute.barMetrics)
            }
        default: break
        }
    }
}
