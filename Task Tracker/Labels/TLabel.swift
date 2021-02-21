//
//  TLabel.swift
//  Task Tracker
//
//

import UIKit

class MILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(font: UIFont, textColor: UIColor) {
        self.init(frame: .zero)
        self.font = font
        self.textColor = textColor
    }
    
    private func configure() {
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = false
        minimumScaleFactor = 0.8
        textAlignment = .left
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
