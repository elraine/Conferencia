//
//  DateView.swift
//  Conferencia
//
//  Created by Angélique Blondel on 27/03/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import Foundation


class DateView {
    
    init (){
        
    }
    
    
    func dateView(date : String) -> String{
        var myArray = date.componentsSeparatedByString("-")
        
        let dayComponents = NSDateComponents()
        dayComponents.year = Int(myArray[0])!
        dayComponents.month = Int(myArray[1])!
        dayComponents.day = Int(myArray[2])!
        
        let day = NSCalendar.currentCalendar().dateFromComponents(dayComponents)!
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EE d"
        
        return dayTimePeriodFormatter.stringFromDate(day)
    }
    
    
    func timeView(time : String) -> String{
        var myArray = time.componentsSeparatedByString(":")
        
        let timeComponents = NSDateComponents()
        timeComponents.hour = Int(myArray[0])!
        timeComponents.minute = Int(myArray[1])!
        
        let time = NSCalendar.currentCalendar().dateFromComponents(timeComponents)!
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.timeStyle = .ShortStyle
        
        return dayTimePeriodFormatter.stringFromDate(time)
        
    }
    
    
}