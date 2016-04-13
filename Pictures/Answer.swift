//
//  Answer.swift
//  Pictures
//
//  Created by 廖慶麟 on 2015/12/23.
//  Copyright © 2015年 廖慶麟. All rights reserved.
//

import Foundation
import CoreData

class Answer:NSManagedObject {
    
    @NSManaged var question:String!
    @NSManaged var answer:String?
    @NSManaged var photo:NSData!
    @NSManaged var create_time:NSDate!

}