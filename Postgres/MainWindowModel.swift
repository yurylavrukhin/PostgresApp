//
//  MainWindowModel.swift
//  Postgres
//
//  Created by Chris on 17/08/2016.
//  Copyright © 2016 postgresapp. All rights reserved.
//

import Cocoa

class MainWindowModel: NSObject {
	@objc dynamic var serverManager = ServerManager.shared
	@objc dynamic var selectedServerIndices = IndexSet()
	@objc dynamic var sidebarVisible = false
	
	var firstSelectedServer: Server? {
		guard let selIdx = selectedServerIndices.first else { return nil }
		return serverManager.servers[selIdx]
	}
	
	func removeSelectedServer() {
		guard let selIdx = selectedServerIndices.first else { return }
		let server = serverManager.servers[selIdx]
		
		if server.isForeign {
			var removedServers = [String]()
			if let defaults = UserDefaults.standard.array(forKey: "RemovedForeignServerBinPaths") as? [String] {
				removedServers = defaults
			}
			removedServers.append(server.binPath)
			UserDefaults.standard.set(removedServers, forKey: "RemovedForeignServerBinPaths")
		}
		
		serverManager.servers.remove(at: selIdx)
		
		if selIdx > 0 {
			selectedServerIndices = IndexSet(integer: selIdx-1)
		} else {
			selectedServerIndices = IndexSet(integer: 0)
		}
	}
}



protocol MainWindowModelConsumer {
	var mainWindowModel: MainWindowModel! { get set }
}