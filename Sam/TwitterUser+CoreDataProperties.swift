//
//  TwitterUser+CoreDataProperties.swift
//  Sam
//
//  Created by Valentina Henao on 12/16/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import Foundation
import CoreData


extension TwitterUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterUser> {
        return NSFetchRequest<TwitterUser>(entityName: "TwitterUser");
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var screenName: String?

}
