
import UIKit

extension NSDate
{
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
    
    func dateView(date : String) -> String{
        var myArray = date.componentsSeparatedByString("-")
        
        let timeStartComponents = NSDateComponents()
        timeStartComponents.year = Int(myArray[0])!
        timeStartComponents.month = Int(myArray[1])!
        timeStartComponents.day = Int(myArray[2])!
        
        let timeStart = NSCalendar.currentCalendar().dateFromComponents(timeStartComponents)!
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EE d"
        
        return dayTimePeriodFormatter.stringFromDate(timeStart)
    }
}