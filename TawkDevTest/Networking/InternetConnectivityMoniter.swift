//
//  InternetConnectivityMoniter.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 15/02/22.
//

import Foundation
import Network

class InternetConnectivityMoniter {
    static var instance = InternetConnectivityMoniter()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetConnectivityMoniter")

    var isInternetConnected: Bool = false {
        didSet {
            onConnectivityStatusUpdate?(isInternetConnected)
        }
    }

    typealias InternetConnectivityEvent = (Bool) -> Void
    var onConnectivityStatusUpdate: InternetConnectivityEvent?

    func start() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isInternetConnected = true
            } else {
                self?.isInternetConnected = false
            }
        }
    }
}
