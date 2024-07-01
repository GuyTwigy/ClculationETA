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
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var timeDistanceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addressLbl.text = ""
        ETALbl.text = ""
    }
    
    func setupCellContent(addressDistanc: AddressDistance) {
        infoView.isHidden = !addressDistanc.infoOpen
        if addressDistanc.isStart ?? false {
            infoView.isHidden = true
        }
        addressLbl.text = addressDistanc.isStart ?? false ? "Start - 📍 \(addressDistanc.address ?? "")" : "📍 \(addressDistanc.address ?? "")"
        ETALbl.text = addressDistanc.isStart ?? false ? "\(addressDistanc.arriveETA ?? "9:00")" : "\(addressDistanc.arriveETA ?? "9:00") ETA"
    }
}
