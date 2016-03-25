//
//  DocDataHelper.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation
import SQLite

class DocDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Docs"
    
    static let table = Table(TABLE_NAME)
    static let docid = Expression<Int64>("docid")
    static let time_start = Expression<String>("time_start")
    static let time_end = Expression<String>("time_end")
    static let title = Expression<String>("title")
    static let abstract = Expression<String?>("abstract")
    static let link = Expression<String?>("link")
    static let eventid = Expression<Int64>("eventid")
    static let perso = Expression<Bool>("perso")
    
    typealias T = Doc
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(docid,primaryKey: true)
                t.column(time_start)
                t.column(time_end)
                t.column(title)
                t.column(abstract)
                t.column(link)
                t.column(eventid)
                t.column(perso, defaultValue : false)
                })
            
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.abstract != nil && item.link != nil) {
            let insert = table.insert(docid <- item.docid, time_start <- item.time_start, time_end <- item.time_end, title <- item.title, abstract <- item.abstract!, link <- item.link!, eventid <- item.eventid)
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
    
    static func upDate(item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(item.docid == docid)
        
        do {
            if try DB.run(query.update(time_start <- item.time_start, time_end <- item.time_end, title <- item.title, abstract <- item.abstract!, link <- item.link!, eventid <- item.eventid)) > 0 {
                print("updated doc")
            } else {
                try insert(item)
                print("insert new doc")
            }
        } catch {
            print("update failed: \(error)")
        }
    }
    
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(item.docid == docid)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
        
    
    }
    
    static func addMyProgram(docid : Int64) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(docid == self.docid)
        do{
            let tmp = try DB.run(query.update(perso <- true))
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
            retArray.append(Doc(docid: item[docid], time_start: item[time_start], time_end: item[time_end], title: item[title], abstract: item[abstract], link: item[link], eventid: item[eventid]))
        }
        
        return retArray
        
    }
    
    
    static func find(docid : Int64 ) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(docid == self.docid)
        
        
        var ret : T? = nil
        let items = try DB.prepare(query)
        for item in items {
            ret = Doc(docid: item[self.docid], time_start: item[time_start], time_end: item[time_end], title: item[title], abstract: item[abstract], link: item[link], eventid: item[eventid])
        }
        
        return ret
        
    }
    
    static func findByEvent(eventid: Int64, perso : Bool? = false) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        var query = table.filter(self.eventid == eventid)
        
        if perso == true{
             query = table.filter(self.eventid == eventid && self.perso == true)
        }
        let items = try DB.prepare(query.order(time_start))
        for item in items {
            retArray.append(Doc(docid: item[docid], time_start: item[time_start], time_end: item[time_end], title: item[title], abstract: item[abstract], link: item[link], eventid: item[self.eventid]))
        }
        
        return retArray
        
    }
    
    
}
