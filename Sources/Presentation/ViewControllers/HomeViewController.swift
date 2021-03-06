//
//  HomeViewController.swift
//  SaldoEMT
//
//  Created by Andrés Pizá on 18/7/15.
//  Copyright (c) 2015 tovkal. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMobileAds

class HomeViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var fareName: UILabel!
    @IBOutlet weak var remainingAmount: UILabel!
    @IBOutlet weak var tripsMade: UILabel!
    @IBOutlet weak var tripsRemaining: UILabel!
    @IBOutlet weak var tripButton: UIButton!
    @IBOutlet weak var busLineType: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!

    var dataManager: DataManagerProtocol!
    var viewModel: HomeViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            fareName.text = viewModel.currentFareName
            tripsMade.text = "\(viewModel.tripsDone)"
            tripsRemaining.text = "\(viewModel.tripsRemaining)"
            remainingAmount.text = viewModel.balance
            guard let url = URL(string: viewModel.imageUrl) else { return }
            busLineType.kf.setImage(with: url)
        }
    }

    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        initBanner()

        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.updateLabels),
                                               name: NSNotification.Name(rawValue: NotificationCenterKeys.busAndFaresUpdate), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = dataManager.getCurrentState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if dataManager.shouldChooseNewFare() {
            chooseNewFare()
        } else if dataManager.isFirstRun() {
            performSegue(withIdentifier: SegueKeys.initialMoney, sender: self)
        }
    }

    // MARK: - Actions

    @IBAction func addTrip(_ sender: UIButton) {
        dataManager.addTrip { errorMessage in
            SVProgressHUD.showError(withStatus: errorMessage)
        }

        updateLabels()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SVProgressHUD.dismiss()
        if segue.identifier == SegueKeys.balance, let vc = segue.destination as? AddMoneyViewController {
            vc.dataManager = dataManager
        } else if segue.identifier == SegueKeys.fares, let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? FaresViewController {
            vc.dataManager = dataManager
        } else if segue.identifier == SegueKeys.initialMoney, let vc = segue.destination as? InitialMoneyViewController {
            vc.dataManager = dataManager
        }
    }

    // MARK: Dev actions

    @IBAction func reset(_ sender: UIButton) {
        dataManager.reset()
        viewModel = dataManager.getCurrentState()
    }

    @IBAction func forceDownload(_ sender: UIButton) {
        dataManager.downloadNewFares(completionHandler: nil)
    }

    // MARK: - Private functions
    @objc fileprivate func updateLabels() {
        DispatchQueue.main.async {
            self.viewModel = self.dataManager.getCurrentState()
        }
    }

    private func chooseNewFare() {
        let alert = UIAlertController(title: "choose-new-fare.alert.title".localized,
                                      message: "choose-new-fare.alert.message".localized,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "buttons.ok".localized,
                                      style: .default, handler: { _ in
                                        self.performSegue(withIdentifier: SegueKeys.fares, sender: self)
        }))
        self.present(alert, animated: true)
    }

    fileprivate func initBanner() {
        if let adUnitID = valueForSecretKey("adUnitID") as? String {
            bannerView.adUnitID = adUnitID
        }
        bannerView.rootViewController = self
        let request = GADRequest()
        if var testDevices = valueForSecretKey("googleAdsTestDeviceIds") as? [Any] {
            testDevices += [kGADSimulatorID]
            request.testDevices = testDevices
        }
        bannerView.load(request)
    }
}
