//
//  News+CoreDataProperties.swift
//  APICall
//
//  Created by Nishanth on 07/08/24.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var dateUrl: String?
    @NSManaged public var detaildescription: String?
    @NSManaged public var imageUrl: Data?
    @NSManaged public var title: String?

}

extension News : Identifiable {
    @nonobjc public class func fetchNews(context: NSManagedObjectContext) async throws -> [News]{
            let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
            
            return try await withCheckedThrowingContinuation { continues in
                context.perform {
                    do{
                        let results = try fetchRequest.execute()
                        continues.resume(returning: results)
                    }
                    catch{
                        continues.resume(throwing: error)
                    }
                }
            }
        }
}

struct NewsModel{
    var title: String
    var dateUrl: String
    var imageUrl: Data
    var detaildescription: String
    
  
}
