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

class CustomButton: UIView {
    
    @IBOutlet weak var addLocationBtn: UIButton!

    weak var delegate: CustomButtonDelegate?
    
    @IBAction func addLocationTapped(_ sender: Any) {
        delegate?.addLocationTapped()
    }
}
