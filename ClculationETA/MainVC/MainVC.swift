//
//  MainVC.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import UIKit
import CoreLocation

class MainVC: UIViewController {
    
    private var vm: MainVM?
    private var addressesDistance: [AddressDistance] = []
    private var pinnedIndexPaths: [IndexPath] = []
    
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
        hideKeyboardWhenTappedAround(cancelTouches: false)
        setupTableView()
        vm = MainVM()
        vm?.delegate = self
    }
    
    func setupTableView() {
        tblLocations.delegate = self
        tblLocations.dataSource = self
        tblLocations.dragDelegate = self
        tblLocations.dropDelegate = self
        tblLocations.dragInteractionEnabled = true
        tblLocations.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tblLocations.register(UINib(nibName: "AddLocationCell", bundle: nil), forCellReuseIdentifier: "AddLocationCell")
        tblLocations.rowHeight = UITableView.automaticDimension
        tblLocations.estimatedRowHeight = 200
    }
    
    func addTapped(address: String) {
        locationTextField.resignFirstResponder()
        loader.startAnimating()
        locationTextField.text = ""
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
    
    @IBAction func resetTapped(_ sender: Any) {
        showConfirmationAlert(title: "Are You Sure", message: "This will erase your addresses list", okAction:  { [weak self] in
            guard let self else {
                return
            }
            
            loader.startAnimating()
            addressesDistance.removeAll()
            tblLocations.reloadData()
            loader.stopAnimating()
            emptyListIndicationLbl.isHidden = !addressesDistance.isEmpty
        })
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addressesDistance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let formerIndex = (indexPath.row - 1) < 0 ? 0 : indexPath.row - 1
        cell.setupCellContent(addressDistanc: addressesDistance[indexPath.row], formerAddress: addressesDistance[formerIndex])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !addressesDistance.isEmpty && indexPath.row != 0 {
            for index in addressesDistance.indices {
                if addressesDistance[index].coordinate?.latitude != addressesDistance[indexPath.row].coordinate?.latitude &&
                    addressesDistance[index].arriveETA != addressesDistance[indexPath.row].arriveETA {
                    addressesDistance[index].infoOpen = false
                }
            }
            addressesDistance[indexPath.row].infoOpen = !addressesDistance[indexPath.row].infoOpen
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            loader.startAnimating()
            addressesDistance.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            addressesDistance = vm?.positionChanged(addressesArr: addressesDistance) ?? []
            tableView.reloadData()
            loader.stopAnimating()
            emptyListIndicationLbl.isHidden = !addressesDistance.isEmpty
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !pinnedIndexPaths.contains(indexPath)
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let addressDistance = addressesDistance[indexPath.row]
        let itemProvider = NSItemProvider(object: "\(addressDistance.address ?? "")" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = addressDistance
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }
        
        if coordinator.proposal.operation == .move {
            let cancelDrop = shouldCancelDrop(sourceIndexPath: coordinator.items.first?.sourceIndexPath, destinationIndexPath: destinationIndexPath)
            if cancelDrop.canDrop {
                showAlert(title: cancelDrop.message, message: "Please close information and drag again")
                return
            }
            
            var destinationIndexPathProperty = destinationIndexPath
            if let item = coordinator.items.first,
               let sourceIndexPath = item.sourceIndexPath {
                if pinnedIndexPaths.contains(destinationIndexPathProperty) {
                    destinationIndexPathProperty.row += 1
                }
                loader.startAnimating()
                tableView.performBatchUpdates({
                    addressesDistance.remove(at: sourceIndexPath.row)
                    addressesDistance.insert(item.dragItem.localObject as! AddressDistance, at: destinationIndexPathProperty.row)
                    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPathProperty)
                    addressesDistance = vm?.positionChanged(addressesArr: addressesDistance) ?? []
                    tableView.reloadData()
                    loader.stopAnimating()
                }, completion: nil)
                coordinator.drop(item.dragItem, toRowAt: destinationIndexPathProperty)
            }
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            locationTextField.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    private func shouldCancelDrop(sourceIndexPath: IndexPath?, destinationIndexPath: IndexPath) -> (canDrop: Bool, message: String) {
        guard let sourceIndexPath else {
            return (false, "")
        }
        
        var nextIndex: Int?
        if sourceIndexPath.row < destinationIndexPath.row {
            nextIndex = destinationIndexPath.row + 1 >= addressesDistance.count ? destinationIndexPath.row - 1 : destinationIndexPath.row + 1
            if let nextIndex, addressesDistance[nextIndex].infoOpen {
                return (true, "Cannot move here while information is open")
            }
        } else if addressesDistance[destinationIndexPath.row].infoOpen {
            return (true, "Cannot move here while information is open")
        }
        
        if addressesDistance[sourceIndexPath.row].infoOpen {
            return (true, "Cannot move adress while information is open")
        }
        
        return (false, "")
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
