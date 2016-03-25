//
//  ConferenceDataHelper.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//


import Foundation
import SQLite

class ConferenceDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Conferences"
    
    static let table = Table(TABLE_NAME)
    static let confid = Expression<Int64>("confid")
    static let link = Expression<String?>("link")
    static let shortname = Expression<String?>("shortname")
    static let name = Expression<String>("name")
    static let description = Expression<String?>("description")
    static let date_begin = Expression<String>("date_begin")
    static let date_end = Expression<String>("date_end")
    static let date_creation = Expression<String>("date_creation")
    static let lat = Expression<String>("lat")
    static let lng = Expression<String>("lng")

    
    
    typealias T = Conference

    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(confid,primaryKey: true)
                t.column(link)
                t.column(shortname)
                t.column(name)
                t.column(description)
                t.column(date_begin)
                t.column(date_end)
                t.column(date_creation)
                t.column(lat)
                t.column(lng)
                })
            
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.link != nil && item.shortname != nil && item.description != nil ) {
            
            let insert = table.insert(or: .Replace,confid<-item.confid, link <- item.link!, shortname <- item.shortname!, name <- item.name, description <- item.description!, date_begin <- item.date_begin, date_end <- item.date_end, date_creation <- item.date_creation, lat <- item.lat, lng <- item.lng)

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
        
        let query = table.filter(item.confid == confid)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
        
        
    }
    
    static func find(id: Int64) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(id == confid)
        let items = try DB.prepare(query)
        for item in  items {
            return Conference(confid: item[confid], link: item[link], shortname: item[shortname], name: item[name], description: item[description], date_begin: item[date_begin], date_end: item[date_end], date_creation: item[date_creation], lat: item[lat], lng: item[lng])
        }
        
        return nil
        
    }
    
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(Conference(confid: item[confid], link: item[link], shortname: item[shortname], name: item[name], description: item[description], date_begin: item[date_begin], date_end: item[date_end], date_creation: item[date_creation], lat: item[lat], lng: item[lng]))
        }
        
        return retArray
        
    }
    
    
}













