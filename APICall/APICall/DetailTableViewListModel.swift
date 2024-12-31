//
//  DetailTableViewListModel.swift
//  APICall
//
//  Created by Nishanth on 07/08/24.
//

import Foundation

class DetailTableViewListModel{
    var detailsArrayModel: [NewsModel]
    
    init(detailsArrayModel: [NewsModel]) {
        self.detailsArrayModel = detailsArrayModel
    }
    
    func numberOfSection() -> Int{
        return 1
    }
    
    func numberOfRowsInSection() -> Int{
        return self.detailsArrayModel.count
    }
    
    func cellForRowAtIndexPath(index: Int) -> NewsModel{
        return self.detailsArrayModel[index]
    }
    
}
