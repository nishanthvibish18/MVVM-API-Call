//
//  NetworkStatus.swift
//  APICall
//
//  Created by Nishanth on 07/08/24.
//

import Foundation
import Network

class NetworkStatus{
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
        private var currentPath: NWPath?
        
        init() {
            monitor = NWPathMonitor()
        }
        
        func startMonitoring() {
            monitor.pathUpdateHandler = { [weak self] path in
                guard let self = self else { return }
                            self.currentPath = path
                            Task {
                                await self.networkStatus()
                            }
            }
            monitor.start(queue: queue)
        }
        
        func stopMonitoring() {
            monitor.cancel()
        }
        
        func networkStatus() async -> Bool{
            guard let path = currentPath else {
                return false
            }
            
            if path.status == .unsatisfied {
                return false
            }
            else{
                return true
            }
        }
}

