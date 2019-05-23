//
//  VolumeData.swift
//  Timely
//
//  Created by 张泽正 on 2019/5/9.
//  Copyright © 2019 monash. All rights reserved.
//

import Foundation
class VolumeData: NSObject, Decodable {
    var units: [String: UnitData]?
    private enum CodingKeys: String, CodingKey {
        case units = "allocated"
    }
}

class UnitData: NSObject, Decodable {
    var subjectCode: String?
    var subjectTitle: String?
    var activityType: String?
    var location: String?
    var staff: String?
    var startTime: String?
    var startDate: String?
    var duration: String?
    var weekPattern: String
    var dayOfWeek: String
//    private enum RootKeys: String, CodingKey {
//        case volumeInfo
//    }
    private enum UnitKeys: String, CodingKey {
        case subjectCode = "subject_code"
        case subjectTitle = "subject_description"
        case activityType = "activityType"
        case location
        case staff
        case startTime = "start_time"
        case startDate = "start_date"
        case duration
        case weekPattern = "week_pattern"
        case dayOfWeek = "day_of_week"
    }
    
    required init(from decoder: Decoder) throws {
        // Get the unit container
        let unitContainer = try decoder.container(keyedBy: UnitKeys.self)
        
        // Get the unit info
        self.subjectCode = try unitContainer.decode(String.self, forKey: .subjectCode)
        self.subjectTitle = try unitContainer.decode(String.self, forKey: .subjectTitle)
        self.activityType = try unitContainer.decode(String.self, forKey: .activityType)
        self.location = try unitContainer.decode(String.self, forKey: .location)
        self.staff = try unitContainer.decode(String.self, forKey: .staff)
        self.startTime = try unitContainer.decode(String.self, forKey: .startTime)
        self.startDate = try unitContainer.decode(String.self, forKey: .startDate)
        self.duration = try unitContainer.decode(String.self, forKey: .duration)
        self.weekPattern = try unitContainer.decode(String.self, forKey: .weekPattern)
        self.dayOfWeek = try unitContainer.decode(String.self, forKey: .dayOfWeek)

        
    }
}


