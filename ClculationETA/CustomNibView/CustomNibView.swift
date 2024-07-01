//
//  CustomNibView.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import UIKit

class CustomNibView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
}

private extension CustomNibView {
    func xibSetup() {
        backgroundColor = .clear
        view = loadNib()
        view.frame = bounds
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: ["childView": view!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: [], metrics: nil, views: ["childView": view!]))
    }
}
