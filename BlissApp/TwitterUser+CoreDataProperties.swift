//
//  TwitterUser+CoreDataProperties.swift
//  BlissApp
//
//  Created by Valentina Henao on 10/31/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import Foundation
import CoreData


extension TwitterUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterUser> {
        return NSFetchRequest<TwitterUser>(entityName: "TwitterUser");
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var screenName: String?
    @NSManaged public var created: NSDate?

}
