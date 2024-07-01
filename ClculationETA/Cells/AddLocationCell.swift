//
//  AddLocationCell.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import UIKit

protocol AddLocationCellDelegate: AnyObject {
    func removeCellTapped()
    func addTapped(address: String)
}

class AddLocationCell: UITableViewCell {

    weak var delegate: AddLocationCellDelegate?
    
    @IBOutlet weak var locationTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        delegate?.addTapped(address: locationTextField.text ?? "")
    }
    
    @IBAction func removeTapped(_ sender: Any) {
        delegate?.removeCellTapped()
    }
}
