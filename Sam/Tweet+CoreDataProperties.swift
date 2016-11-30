//
//  Tweet+CoreDataProperties.swift
//  Sam
//
//  Created by Valentina Henao on 11/29/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet");
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var createdBy: String?
    @NSManaged public var id: String?
    @NSManaged public var retweeted: Int64
    @NSManaged public var text: String?
    @NSManaged public var type: String?

}
