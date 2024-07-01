//
//  LocationCell.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var ETALbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addressLbl.text = ""
        ETALbl.text = ""
    }
    
    func setupCellContent(addressDistanc: AddressDistance) {
        if addressDistanc.isStart ?? false {
            ETALbl.isHidden =  true
            addressLbl.text = "Start - 📍 \(addressDistanc.address ?? "")"
        } else {
            ETALbl.isHidden = false
            ETALbl.text = "\(addressDistanc.ETA ?? 0)"
            addressLbl.text = "📍 \(addressDistanc.address ?? "")"
        }
        
    }
}
