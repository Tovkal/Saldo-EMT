//
//  ViewController.swift
//  SaldoEMT
//
//  Created by Andrés Pizá on 18/7/15.
//  Copyright (c) 2015 tovkal. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMobileAds

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var fareName: UILabel!
    @IBOutlet weak var remainingAmount: UILabel!
    @IBOutlet weak var tripsMade: UILabel!
    @IBOutlet weak var tripsRemaining: UILabel!
    @IBOutlet weak var tripButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBanner()
        
        Store.sharedInstance.initFare()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateLabels), name: NSNotification.Name(rawValue: BUS_AND_FARES_UPDATE), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLabels()
    }
    
    // MARK: - Actions
    
    @IBAction func addTrip(_ sender: UIButton) {
        if let errorMessage = Store.sharedInstance.addTrip() {
            SVProgressHUD.showError(withStatus: errorMessage)
        }
        
        updateLabels()
    }
    
    // MARK: Dev actions
    
    @IBAction func reset(_ sender: UIButton) {
        Store.sharedInstance.reset()
        updateLabels()
    }
    
    @IBAction func forceDownload(_ sender: UIButton) {
        Store.sharedInstance.updateFares(performFetchWithCompletionHandler: nil)
    }
    
    // MARK: - Private functions
    
    fileprivate func setupLabels() {
        log.debug("Setting up labels")
        fareName.text = Store.sharedInstance.getSelectedFare()
        tripsMade.text = "\(Store.sharedInstance.getTripsDone())"
        tripsRemaining.text = "\(Store.sharedInstance.getTripsRemaining())"
        remainingAmount.text = Store.sharedInstance.getRemainingBalance().toDecimalString()
    }
    
    @objc fileprivate func updateLabels() {
        DispatchQueue.main.async {
            self.setupLabels()
        }
    }
    
    fileprivate func initBanner() {
        bannerView.adUnitID = "ca-app-pub-0951032527002077/6731131411"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
}


