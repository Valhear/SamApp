//
//  brainForTweets.swift
//  BlissApp
//
//  Created by Valentina Henao on 10/17/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import Foundation
import CoreData


class brainForTweets: NSObject {
    
//    var managedObjectContext: NSManagedObjectContext
//    var retweeted = [NSManagedObject]()
    
//    override init() {
//        // This resource is the same name as your xcdatamodeld contained in your project.
//        guard let modelURL = Bundle.main.url(forResource: "BlissApp", withExtension:"xcdatamodeld") else {
//            fatalError("Error loading model from bundle")
//        }
//        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
//            fatalError("Error initializing mom from: \(modelURL)")
//        }
//        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
//        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        
//        managedObjectContext.persistentStoreCoordinator = psc
//        
//        DispatchQueue.global(qos: .background).async {
//            DispatchQueue.main.async {
//                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//                let docURL = urls[urls.endIndex-1]
//                /* The directory the application uses to store the Core Data store file.
//                 This code uses a file named "DataModel.sqlite" in the application's documents directory.
//                 */
//                let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
//                do {
//                    try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
//                } catch {
//                    fatalError("Error migrating store: \(error)")
//                }
//            }
//            }
//    }
}
