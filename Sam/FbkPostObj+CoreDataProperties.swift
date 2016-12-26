//
//  FbkPostObj+CoreDataProperties.swift
//  Sam
//
//  Created by Valentina Henao on 12/16/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import Foundation
import CoreData


extension FbkPostObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FbkPostObj> {
        return NSFetchRequest<FbkPostObj>(entityName: "FbkPostObj");
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var descriptn: String?
    @NSManaged public var from: String?
    @NSManaged public var link: String?
    @NSManaged public var message: String?
    @NSManaged public var reactions: Int64
    @NSManaged public var type: String?

}
