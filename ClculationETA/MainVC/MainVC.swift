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
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: CustomButton! {
        didSet {
            addBtn.delegate = self
        }
    }
    @IBOutlet weak var emptyListIndicationLbl: UILabel!
    @IBOutlet weak var tblLocations: UITableView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addLocationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addLocationView: UIView! {
        didSet {
            addLocationView.isHidden = true
        }
    }
    
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
        tblLocations.rowHeight = UITableView.automaticDimension
        tblLocations.estimatedRowHeight = 200
    }
    
    func addTapped(address: String) {
        loader.startAnimating()
        addressesDistance.append(AddressDistance(address: address, distanceETA: nil, arriveETA: nil, isStart: nil, coordinate: nil))
        Task {
            try await vm?.getDistance(addressesArr: addressesDistance)
        }
    }
    
    @IBAction func removeTopCellTApped(_ sender: Any) {
        addLocationViewHeightConstraint.constant = 0
        addLocationView.isHidden = true
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if locationTextField.text != nil && !(locationTextField.text?.isEmpty ?? false) {
            addTapped(address: locationTextField.text ?? "")
        }
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addressesDistance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        cell.setupCellContent(addressDistanc: addressesDistance[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !addressesDistance.isEmpty {
            for index in addressesDistance.indices {
                if addressesDistance[index].coordinate?.latitude != addressesDistance[indexPath.row].coordinate?.latitude {
                    addressesDistance[index].infoOpen = false
                }
            }
            addressesDistance[indexPath.row].infoOpen = !addressesDistance[indexPath.row].infoOpen
            tableView.reloadData()
        }
    }
}

extension MainVC: CustomButtonDelegate {
    func addLocationTapped() {
        addLocationViewHeightConstraint.constant = 60
        addLocationView.isHidden = false
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
