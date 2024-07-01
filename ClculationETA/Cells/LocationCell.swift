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
        addressLbl.text = addressDistanc.isStart ?? false ? "Start - 📍 \(addressDistanc.address ?? "")" : "📍 \(addressDistanc.address ?? "")"
        ETALbl.text = addressDistanc.isStart ?? false ? "\(addressDistanc.ETA ?? "9:00")" : "\(addressDistanc.ETA ?? "9:00") ETA"
    }
}
