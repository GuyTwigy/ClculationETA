//
//  MainVC.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import UIKit
import CoreLocation

class MainVC: UIViewController {

    var locationList: [Location] = []
    var addCellOpen: Bool = false
    
    @IBOutlet weak var tblLocations: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func setupTableView() {
        tblLocations.delegate = self
        tblLocations.dataSource = self
        tblLocations.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
    }

}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addCellOpen ? locationList.count + 1 : locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
    }
}
