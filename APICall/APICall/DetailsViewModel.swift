//
//  DetailsViewModel.swift
//  APICall
//
//  Created by Nishanth on 07/08/24.
//

import Foundation
import CoreData
import UIKit

protocol UpdateData{
    func updateData(success: Bool, error: String?)
}

class DetailsViewModel{
    
    var tableViewCellModel: DetailTableViewListModel?
    var delegate: UpdateData?
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    //    MARK: Fetch Data From Local Data Base
    func fetchData(isApiCalled: Bool,networkStatus: Bool) async{
        do{
            let fetchresult = try await News.fetchNews(context: appDelegate)
         

            
            if (fetchresult.count > 0 && networkStatus == false) || isApiCalled == true{
                let result = self.convertArrayModel(fetchResut: fetchresult)
                self.tableViewCellModel = DetailTableViewListModel(detailsArrayModel: result)
                self.delegate?.updateData(success: true, error: nil)
            }
            else{
                await self.apiCall()
            }
            
        }
        catch{
            print("error")
        }
    }
    

    
    //    MARK: save data in coredata
    private func saveContext(newsData: [NewsModel]) async throws{
        do{
            let fetchResult = try await News.fetchNews(context: appDelegate)
        
            let existingDataDict = Dictionary(uniqueKeysWithValues: fetchResult.map { ($0.title, $0) })
            
            try await appDelegate.perform{ [self] in
                for newsDetails in newsData {
                    if (existingDataDict[newsDetails.title] == nil){
                        let saveContext = News(context: appDelegate)
                        saveContext.dateUrl = newsDetails.dateUrl
                        saveContext.imageUrl = newsDetails.imageUrl
                        saveContext.title = newsDetails.title
                        saveContext.detaildescription = newsDetails.detaildescription
                    }
                }
                if appDelegate.hasChanges{
                    do{
                        try appDelegate.save()
                    }
                    catch{
                        throw error
                    }
                }
            }
        }
        catch{
            print("error")
        }
    }
    
    
    
    //    MARK: Api call
    func apiCall() async{
        do{
            let apiRequest = APIRequestBuilder.description
            let result = try await WebService.sharedInstance.webRequest(request: apiRequest)
            let responses: [NewsModel] = result.response?.docs!.map({ docs in
                return NewsModel(title: docs.headline?.main ?? "", dateUrl: self.convertTimeToLocal(dateString: docs.pub_date ?? ""), imageUrl: self.imageToData(urlString: docs.multimedia?.first?.url ?? "")!, detaildescription: docs.abstract ?? "")
            }) ?? []
            try await self.saveContext(newsData: responses)
            await self.fetchData(isApiCalled: true, networkStatus: true)
        }
        catch{
            let errors = error as? NetworkError
            self.delegate?.updateData(success: false, error: errors?.localizedError ?? "")
        }
    }
    
    
    //    MARK: Image Convert To Data
    private func imageToData(urlString: String) -> Data?{
        guard let urlString = URL(string: "https://www.nytimes.com/\(urlString)") else { return nil }
        
        return try! Data(contentsOf: urlString)
    }
    
    //    MARK: Core Data Model Convert To Newa Model
    private func convertArrayModel(fetchResut: [News]) -> [NewsModel]{
        let responses: [NewsModel] = fetchResut.map({ docs in
            return NewsModel(title: docs.title ?? "", dateUrl: docs.dateUrl ?? "", imageUrl: docs.imageUrl!, detaildescription: docs.detaildescription ?? "")
        })
        return responses
    }
    
    
    //    MARK: Converting Date to Local Date Format
    private func convertTimeToLocal(dateString: String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM-yyyy"
        outputFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        if let date = inputFormatter.date(from: dateString) {
            let dateTextStr = outputFormatter.string(from: date)
            return dateTextStr
            
        }
        
        return ""
    }
    
    
}


