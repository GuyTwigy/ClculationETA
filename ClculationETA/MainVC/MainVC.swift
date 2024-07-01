//
//  MainVC.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import UIKit
import CoreLocation

class MainVC: UIViewController {
    
    var vm: MainVM?
    var addressesDistance: [AddressDistance] = []
    var addCellOpen: Bool = false
    
    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
//            loader.startAnimating()
        }
    }
    @IBOutlet weak var addBtn: CustomButton! {
        didSet {
            addBtn.delegate = self
        }
    }
    @IBOutlet weak var emptyListIndicationLbl: UILabel!
    @IBOutlet weak var tblLocations: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        vm = MainVM()
        vm?.delegate = self
    }

    func setupTableView() {
        tblLocations.delegate = self
        tblLocations.dataSource = self
        tblLocations.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tblLocations.register(UINib(nibName: "AddLocationCell", bundle: nil), forCellReuseIdentifier: "AddLocationCell")
    }

}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addCellOpen ? addressesDistance.count + 1 : addressesDistance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if addCellOpen && indexPath.row == 0 {
            let addCell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell", for: indexPath) as! AddLocationCell
            addCell.locationTextField.text = ""
            addCell.delegate = self
            cell = addCell
        } else if addCellOpen {
            let locationCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            locationCell.setupCellContent(addressDistanc: addressesDistance[indexPath.row - 1])
            cell = locationCell
        } else {
            let locationCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            locationCell.setupCellContent(addressDistanc: addressesDistance[indexPath.row])
            cell = locationCell
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension MainVC: CustomButtonDelegate {
    func addLocationTapped() {
        addCellOpen = true
        tblLocations.reloadData()
    }
}

extension MainVC: AddLocationCellDelegate {
    func removeCellTapped() {
        addCellOpen = false
        tblLocations.reloadData()
    }
    
    func addTapped(address: String) {
        loader.startAnimating()
        addressesDistance.append(AddressDistance(address: address, ETA: nil, isStart: nil))
        Task {
            try await vm?.getDistance(addressesArr: addressesDistance)
        }
    }
}

extension MainVC: MainVMDelegate {
    func distanceBetweenAddresses(addressesDistance: [AddressDistance]?, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let error {
                showAlert(title: "Something went wrong, Please try again later", message: error.localizedDescription)
            } else {
                self.addressesDistance.removeAll()
                self.addressesDistance = addressesDistance ?? []
                self.emptyListIndicationLbl.isHidden = !self.addressesDistance.isEmpty
                self.tblLocations.reloadData()
            }
            self.loader.stopAnimating()
        }
    }
}
