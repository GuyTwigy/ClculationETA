//
//  CustomButton.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import Foundation
import UIKit

protocol CustomButtonDelegate: AnyObject {
    func addLocationTapped()
}

class CustomButton: CustomNibView {
    
    weak var delegate: CustomButtonDelegate?
    
    @IBOutlet weak var addLocationBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "CustomButton", bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        delegate?.addLocationTapped()
    }
}
