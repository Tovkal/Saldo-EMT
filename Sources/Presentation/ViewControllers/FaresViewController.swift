//
//  LineViewController.swift
//  SaldoEMT
//
//  Created by Andrés Pizá Bückmann on 10/10/15.
//  Copyright © 2015 tovkal. All rights reserved.
//

import UIKit

private let fareIdentifier = "FareCell"
private let fareWithRidesIdentifier = "FareWithLimitedRidesCell"
private let fareWithUnlimitedRidesIdentifier = "FareWithUnlimitedRidesCell"

class FaresViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate var fares: [Fare]!

    var dataManager: DataManagerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "FareCell", bundle: nil), forCellReuseIdentifier: fareIdentifier)
        tableView.register(UINib(nibName: "FareWithLimitedRidesCell", bundle: nil), forCellReuseIdentifier: fareWithRidesIdentifier)
        tableView.register(UINib(nibName: "FareWithUnlimitedRidesCell", bundle: nil), forCellReuseIdentifier: fareWithUnlimitedRidesIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200.0
    }

    override func viewWillAppear(_ animated: Bool) {
        fares = dataManager.getAllFares()
    }

    @IBAction func didCancelFareSelection(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FaresViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fares.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fare = fares[indexPath.row]

        let completionHandler = { [weak self] in
            guard let visibleRows = self?.tableView.indexPathsForVisibleRows else { return }
            if visibleRows.contains(indexPath) {
                DispatchQueue.main.async {
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
            }
        }

        if fare.rides.value == nil && fare.days.value == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: fareIdentifier, for: indexPath) as! FareCell
            // swiftlint:disable:previous force_cast

            cell.populateWithFare(fare, completionHandler: completionHandler)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: fareWithRidesIdentifier, for: indexPath) as! FareWithLimitedRidesCell
            // swiftlint:disable:previous force_cast

            cell.populateWithFare(fare, completionHandler: completionHandler)

            return cell
        }
    }
}

extension FaresViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            self.dataManager.selectNewFare(self.fares[indexPath.row])
            log.debug("Selected fare: \(self.fares[indexPath.row].name)")
            self.dismiss(animated: true, completion: nil)
        })
    }
}
