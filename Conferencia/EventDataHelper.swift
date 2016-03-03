//
//  EventDataHelper.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation
import SQLite

class EventDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Events"
    
    static let table = Table(TABLE_NAME)
    static let eventid = Expression<Int64>("eventid")
    static let date = Expression<String>("date")
    static let time_start = Expression<String>("time_start")
    static let time_end = Expression<String>("time_end")
    static let type = Expression<String>("type")
    static let shorttitle = Expression<String?>("shorttitle")
    static let title = Expression<String>("title")
    static let chairman = Expression<String?>("chairman")
    static let roomid = Expression<Int64>("roomid")

    
    
    typealias T = Event

    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(eventid,primaryKey: true)
                t.column(date)
                t.column(time_start)
                t.column(time_end)
                t.column(type)
                t.column(shorttitle)
                t.column(title)
                t.column(chairman)
                t.column(roomid)
                })
            
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.shorttitle != nil && item.chairman != nil ) {
            let insert = table.insert(eventid <- item.eventid, date <- item.date, time_start <- item.time_start, time_end <- item.time_end, type <- item.type, shorttitle <- item.shorttitle!, title <- item.title, chairman <- item.chairman, roomid <- item.roomid)
            do {
                let rowId = try DB.run(insert) 
                guard rowId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowId
            } catch _ {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
        
    }
    
    
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
     
        let query = table.filter(item.eventid == eventid)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
        
        
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(Event(eventid: item[eventid], date: item[date], time_start: item[time_start], time_end: item[time_end], type: item[type], shorttitle: item[shorttitle], title: item[title], chairman: item[chairman], roomid: item[roomid]))
        }
        
        return retArray
        
    }
    
    static func findEventByDay(date: String) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        
        let query = table.filter(date == self.date)
        
        let items = try DB.prepare(query)
        for item in items {
            retArray.append(Event(eventid: item[eventid], date: item[self.date], time_start: item[time_start], time_end: item[time_end], type: item[type], shorttitle: item[shorttitle], title: item[title], chairman: item[chairman], roomid: item[roomid]))
        }
        
        return retArray
    }
    
    
    
    static func findEventByDayTime(date: String, time_start: String) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        
        let query = table.filter(date == self.date && time_start == self.time_start)
        
        let items = try DB.prepare(query)
        for item in items {
            retArray.append(Event(eventid: item[eventid], date: item[self.date], time_start: item[self.time_start], time_end: item[time_end], type: item[type], shorttitle: item[shorttitle], title: item[title], chairman: item[chairman], roomid: item[roomid]))
        }
        
        return retArray
    }
    
    
    static func findEventType(type: String) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        
        let query = table.filter(type == self.type)
        
        let items = try DB.prepare(query)
        for item in items {
            retArray.append(Event(eventid: item[eventid], date: item[date], time_start: item[time_start], time_end: item[time_end], type: item[self.type], shorttitle: item[shorttitle], title: item[title], chairman: item[chairman], roomid: item[roomid]))
        }
        
        return retArray
    }
    
    
    static func findEventTypeAndDay(date: String, type: String) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        
        let query = table.filter(type == self.type && date == self.date)
        
        let items = try DB.prepare(query)
        for item in items {
            retArray.append(Event(eventid: item[eventid], date: item[self.date], time_start: item[time_start], time_end: item[time_end], type: item[self.type], shorttitle: item[shorttitle], title: item[title], chairman: item[chairman], roomid: item[roomid]))
        }
        
        return retArray
    }
    
    static func findTimeSlotByDay(date: String) throws -> [String]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [String]()
        
        let query = table.filter(date == self.date)
        
        let items = try DB.prepare(query.select(distinct: time_start))
        for item in items {
            retArray.append(item[time_start])
        }
        
        return retArray
    }


}









